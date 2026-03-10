#!/usr/bin/env bash
set -euo pipefail

HIDE_ID="${HIDE_ID:-1}"
HIDE_IMAGE="/home/semignu/Pictures/black.jpg"
SHOW_IMAGE="/home/semignu/Pictures/cherry-wallpaper.jpeg"
HIDE_STEP="25"
SHOW_STEP="15"
TRANSITION_FPS="120"

bar_hidden=""

hide_bar() {
  killall -SIGUSR1 waybar 2>/dev/null || true
}

show_bar() {
  killall -SIGUSR2 waybar 2>/dev/null || true
}

set_wallpaper() {
  local image_path="$1"
  local step="$2"

  if command -v awww >/dev/null 2>&1; then
    awww img "$image_path" --transition-step "$step" --transition-fps "$TRANSITION_FPS" || true
  fi
}

apply_visibility_state() {
  local should_hide="$1"

  if [[ "$bar_hidden" == "$should_hide" ]]; then
    return
  fi

  bar_hidden="$should_hide"
  if [[ "$should_hide" == "1" ]]; then
    hide_bar
    set_wallpaper "$HIDE_IMAGE" "$HIDE_STEP"
  else
    show_bar
    set_wallpaper "$SHOW_IMAGE" "$SHOW_STEP"
  fi
}

extract_focused_id() {
  local line="$1"
  local focused_id=""

  focused_id="$(jq -r '.WorkspaceActivated.id // empty' <<<"$line" 2>/dev/null || true)"
  if [[ -n "$focused_id" ]]; then
    printf '%s\n' "$focused_id"
    return 0
  fi

  focused_id="$(jq -r '.WorkspacesChanged.workspaces? // [] | map(select(.is_focused == true)) | .[0].id // empty' <<<"$line" 2>/dev/null || true)"
  if [[ -n "$focused_id" ]]; then
    printf '%s\n' "$focused_id"
  fi
}

consume_event_stream_once() {
  if [[ -z "${NIRI_SOCKET:-}" ]]; then
    echo "hide.sh: NIRI_SOCKET is not set; waiting for environment" >&2
    return 1
  fi

  while IFS= read -r line; do
    jq -e . >/dev/null 2>&1 <<<"$line" || continue

    focused_id="$(extract_focused_id "$line" || true)"
    [[ -z "$focused_id" ]] && continue

    if [[ "$focused_id" == "$HIDE_ID" ]]; then
      apply_visibility_state "1"
    else
      apply_visibility_state "0"
    fi
  done < <({ printf '"EventStream"\n'; cat; } | socat - UNIX-CONNECT:"$NIRI_SOCKET")
}

while true; do
  if consume_event_stream_once; then
    continue
  fi
  sleep 0.1
done
