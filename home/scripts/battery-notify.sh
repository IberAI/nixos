set -eu

# systemd sets these; fallbacks just in case
: "${XDG_RUNTIME_DIR:=/run/user/$(id -u)}"
: "${XDG_STATE_HOME:=$HOME/.local/state}"

# Prefer a power_supply whose type is Battery (more robust than BAT0)
BAT_PATH="$(
  for p in /sys/class/power_supply/*; do
    [ -f "$p/type" ] && [ "$(cat "$p/type" 2>/dev/null)" = "Battery" ] && { echo "$p"; break; }
  done
)"
[ -n "${BAT_PATH:-}" ] || exit 0

CAP="$(cat "$BAT_PATH/capacity" 2>/dev/null || echo 0)"
STATUS="$(cat "$BAT_PATH/status" 2>/dev/null || echo Unknown)"

STATE_DIR="$XDG_STATE_HOME/battery-notify"
STATE_FILE="$STATE_DIR/state"
mkdir -p "$STATE_DIR"

# Persist last values so we only notify on THRESHOLD CROSSINGS.
LAST_CAP=""
LAST_STATUS=""
if [ -f "$STATE_FILE" ]; then
  # shellcheck disable=SC1090
  . "$STATE_FILE" || true
fi

# First run: record and exit (prevents “boot spam”)
if [ -z "${LAST_CAP:-}" ] || [ -z "${LAST_STATUS:-}" ]; then
  {
    echo "LAST_CAP=$CAP"
    echo "LAST_STATUS=$STATUS"
  } > "$STATE_FILE"
  exit 0
fi

# Stable replace IDs (extra safety against stacking)
notify() {
  # $1 urgency, $2 title, $3 body, $4 replace_id
  dunstify -u "$1" -r "$4" "$2" "$3"
}

# Low: discharging and crossing >20 -> <=20
if [ "$STATUS" = "Discharging" ]; then
  if [ "$LAST_CAP" -gt 20 ] && [ "$CAP" -le 20 ]; then
    notify critical "Battery low" "Battery is at ${CAP}%." 42020
  fi
# High: charging and crossing <80 -> >=80
elif [ "$STATUS" = "Charging" ]; then
  if [ "$LAST_CAP" -lt 80 ] && [ "$CAP" -ge 80 ]; then
    notify normal "Battery at 80%" "Battery reached ${CAP}%." 42080
  fi
fi

# Record for next run
{
  echo "LAST_CAP=$CAP"
  echo "LAST_STATUS=$STATUS"
} > "$STATE_FILE"
