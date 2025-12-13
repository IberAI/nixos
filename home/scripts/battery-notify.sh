set -eu

: "${XDG_RUNTIME_DIR:=/run/user/$(id -u)}"
: "${XDG_STATE_HOME:=$HOME/.local/state}"

BAT_PATH="$(
  for p in /sys/class/power_supply/*; do
    [ -f "$p/type" ] && [ "$(cat "$p/type" 2>/dev/null)" = "Battery" ] && { echo "$p"; break; }
  done
)"
[ -n "${BAT_PATH:-}" ] || exit 0

CAP="$(cat "$BAT_PATH/capacity" 2>/dev/null || echo 0)"
STATUS="$(cat "$BAT_PATH/status" 2>/dev/null || echo Unknown)"

case "$CAP" in ''|*[!0-9]*) CAP=0 ;; esac

STATE_DIR="$XDG_STATE_HOME/battery-notify"
STATE_FILE="$STATE_DIR/state"
mkdir -p "$STATE_DIR"

LOW_ID=42020
HIGH_ID=42080

LOW_T=15000   # ms
HIGH_T=8000   # ms

notify() {
  # $1 urgency, $2 title, $3 body, $4 replace_id, $5 timeout_ms
  dunstify -u "$1" -r "$4" -t "$5" "$2" "$3"
}

close_id() {
  dunstify -C "$1" >/dev/null 2>&1 || true
}

write_state() {
  # Quote STATUS safely (handles "Not charging")
  printf 'LAST_CAP=%s\nLAST_STATUS=%q\n' "$CAP" "$STATUS" > "$STATE_FILE"
}

LAST_CAP=""
LAST_STATUS=""
if [ -f "$STATE_FILE" ]; then
  # shellcheck disable=SC1090
  . "$STATE_FILE" || true
fi

if [ -z "${LAST_CAP:-}" ] || [ -z "${LAST_STATUS:-}" ]; then
  write_state
  exit 0
fi

need_close_low=0
need_close_high=0

# Close low warning if we stopped discharging OR rose above 20%
if [ "$LAST_STATUS" = "Discharging" ] && [ "$STATUS" != "Discharging" ]; then need_close_low=1; fi
if [ "$LAST_CAP" -le 20 ] && [ "$CAP" -gt 20 ]; then need_close_low=1; fi

# Close 80% notice if we stopped charging OR dropped below 80%
if [ "$LAST_STATUS" = "Charging" ] && [ "$STATUS" != "Charging" ]; then need_close_high=1; fi
if [ "$LAST_CAP" -ge 80 ] && [ "$CAP" -lt 80 ]; then need_close_high=1; fi

[ "$need_close_low" -eq 1 ] && close_id "$LOW_ID"
[ "$need_close_high" -eq 1 ] && close_id "$HIGH_ID"

# If nothing changed and no closes needed, exit (lowest CPU)
if [ "$CAP" = "$LAST_CAP" ] && [ "$STATUS" = "$LAST_STATUS" ] && \
   [ "$need_close_low" -eq 0 ] && [ "$need_close_high" -eq 0 ]; then
  exit 0
fi

if [ "$STATUS" = "Discharging" ]; then
  # Crossing >20 -> <=20
  if [ "$LAST_CAP" -gt 20 ] && [ "$CAP" -le 20 ]; then
    notify critical "Battery low" "Battery is at ${CAP}%." "$LOW_ID" "$LOW_T"
  fi

  # Optional: if you just unplugged while already low, warn
  if [ "$LAST_STATUS" != "Discharging" ] && [ "$CAP" -le 20 ]; then
    notify critical "Battery low" "Battery is at ${CAP}%." "$LOW_ID" "$LOW_T"
  fi

elif [ "$STATUS" = "Charging" ]; then
  # Crossing <80 -> >=80
  if [ "$LAST_CAP" -lt 80 ] && [ "$CAP" -ge 80 ]; then
    notify normal "Battery at 80%" "Battery reached ${CAP}%." "$HIGH_ID" "$HIGH_T"
  fi

  # Optional: if you just plugged in while already >=80, remind
  if [ "$LAST_STATUS" != "Charging" ] && [ "$CAP" -ge 80 ]; then
    notify normal "Battery at 80%" "Battery reached ${CAP}%." "$HIGH_ID" "$HIGH_T"
  fi
fi

write_state
