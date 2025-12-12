set -eu

# systemd sets this; fallback just in case
: "${XDG_RUNTIME_DIR:=/run/user/$(id -u)}"

# Prefer a power_supply whose type is Battery (more robust than BAT0)
BAT_PATH="$(
  for p in /sys/class/power_supply/*; do
    [ -f "$p/type" ] && [ "$(cat "$p/type" 2>/dev/null)" = "Battery" ] && { echo "$p"; break; }
  done
)"
[ -n "${BAT_PATH:-}" ] || exit 0

CAP="$(cat "$BAT_PATH/capacity" 2>/dev/null || echo 0)"
STATUS="$(cat "$BAT_PATH/status" 2>/dev/null || echo Unknown)"

STATE_DIR="$XDG_RUNTIME_DIR/battery-notify"
STATE_FILE="$STATE_DIR/state"
mkdir -p "$STATE_DIR"
LAST="$(cat "$STATE_FILE" 2>/dev/null || true)"

notify() { dunstify -u "$1" "$2" "$3"; }

case "$STATUS" in
  Discharging)
    if [ "$CAP" -le 20 ] && [ "$LAST" != "low" ]; then
      notify critical "Battery low" "Battery is at ${CAP}%."
      echo low > "$STATE_FILE"
    elif [ "$CAP" -ge 25 ] && [ "$LAST" = "low" ]; then
      : > "$STATE_FILE"
    fi
    ;;
  Charging)
    if [ "$CAP" -ge 80 ] && [ "$LAST" != "high" ]; then
      notify normal "Battery at 80%" "Battery reached ${CAP}%."
      echo high > "$STATE_FILE"
    elif [ "$CAP" -le 75 ] && [ "$LAST" = "high" ]; then
      : > "$STATE_FILE"
    fi
    ;;
  Full)
    if [ "$LAST" != "high" ]; then
      notify low "Battery full" "Battery is full."
      echo high > "$STATE_FILE"
    fi
    ;;
esac
