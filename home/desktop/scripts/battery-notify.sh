#!/usr/bin/env bash
set -euo pipefail

# --- thresholds ---
LOW_PCT=20
CRIT_PCT=5

LOW_TIMEOUT_MS=20000
CRIT_TIMEOUT_MS=15000

# fixed notification id so we can replace/close our notif cleanly
NOTIF_ID=9900

STATE_FILE="${XDG_STATE_HOME:-$HOME/.local/state}/battery-dunst.state"
mkdir -p "$(dirname "$STATE_FILE")"

have() { command -v "$1" >/dev/null 2>&1; }

close_notif() {
  # best-effort close depending on dunst/dunstify version
  if have dunstify; then dunstify -C "$NOTIF_ID" >/dev/null 2>&1 || true; fi
  if have dunstctl; then dunstctl close "$NOTIF_ID" >/dev/null 2>&1 || true; fi
}

find_supply_by_type() {
  local want="$1"
  for d in /sys/class/power_supply/*; do
    [[ -r "$d/type" ]] || continue
    [[ "$(cat "$d/type")" == "$want" ]] && { echo "$d"; return 0; }
  done
  return 1
}

check_once() {
  local bat ac capacity status ac_online last

  bat="$(find_supply_by_type Battery || true)"
  ac="$(find_supply_by_type Mains   || true)"
  [[ -n "${bat:-}" ]] || return 0

  capacity="$(< "$bat/capacity")"
  status="$(< "$bat/status")"

  ac_online=0
  if [[ -n "${ac:-}" && -r "$ac/online" ]]; then
    ac_online="$(< "$ac/online")"
  fi

  last="none"
  [[ -r "$STATE_FILE" ]] && last="$(< "$STATE_FILE")"

  # plugged in or charging? close our battery notif immediately.
  if [[ "$ac_online" -eq 1 || "$status" == "Charging" ]]; then
    close_notif
    echo "none" > "$STATE_FILE"
    return 0
  fi

  # only warn while actually discharging
  if [[ "$status" != "Discharging" ]]; then
    echo "none" > "$STATE_FILE"
    return 0
  fi

  if (( capacity < CRIT_PCT )); then
    if [[ "$last" != "crit" ]]; then
      dunstify -r "$NOTIF_ID" -u critical -t "$CRIT_TIMEOUT_MS" \
        "Battery critically low" "Battery at ${capacity}% — plug in now."
      echo "crit" > "$STATE_FILE"
    fi
    return 0
  fi

  if (( capacity < LOW_PCT )); then
    if [[ "$last" == "none" ]]; then
      dunstify -r "$NOTIF_ID" -u normal -t "$LOW_TIMEOUT_MS" \
        "Battery low" "Battery at ${capacity}%."
      echo "low" > "$STATE_FILE"
    fi
    return 0
  fi

  # recovered above LOW threshold -> allow future warnings again
  echo "none" > "$STATE_FILE"
}

daemon() {
  check_once

  # event-driven: blocks and wakes on power events (no polling)
  if have upower; then
    upower --monitor 2>/dev/null | while IFS= read -r _; do
      check_once
    done
  else
    udevadm monitor --udev --subsystem-match=power_supply 2>/dev/null \
      | while IFS= read -r line; do
          [[ "$line" == UDEV\ * ]] && check_once
        done
  fi
}

case "${1:-}" in
  --daemon) daemon ;;
  *)        check_once ;;
esac
