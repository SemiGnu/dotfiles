#!/usr/bin/env bash
echo "starting"
sleep 5
set -euo pipefail

HIDE_ID="1"
hide_bar() { killall -SIGUSR1 waybar 2>/dev/null || true; }
show_bar() { killall -SIGUSR2 waybar 2>/dev/null || true; }

# Request EventStream then keep stdin open.
{ printf '"EventStream"\n'; cat; } |
socat - UNIX-CONNECT:"$NIRI_SOCKET" |
while IFS= read -r line; do
  # Ignore non-JSON / empty lines safely
  jq -e . >/dev/null 2>&1 <<<"$line" || continue
  echo "Received event"
  # We only care about WorkspacesChanged because it contains the focused workspace + its name.
  if jq -e 'has("WorkspaceActivated")' >/dev/null <<<"$line"; then
    echo "Received real event"
    focused_id="$(
      jq -r '
        .WorkspaceActivated.id
      ' <<<"$line" 2>/dev/null | head -n1
    )"

    if [[ "$focused_id" == "$HIDE_ID" ]]; then
      echo "Received real real event"
      hide_bar
      awww img "/home/semignu/Pictures/black.jpg" --transition-step 25 --transition-fps 120 
    else
      echo "Received real fake event"
      show_bar
      awww img "/home/semignu/Pictures/cherry-wallpaper.jpeg" --transition-step 15 --transition-fps 120 
    fi
  fi
done
