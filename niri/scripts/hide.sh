#!/usr/bin/env bash
set -euo pipefail

HIDE_ID="${1:-1}"
BAR_INDEX="${BAR_INDEX:-0}"

PARADOX_PRESET_TITLES=(
  "Europa Universalis IV"
  "Crusader Kings III"
)

TOOLBAR_PRESET_TITLES=(
  "World of Warcraft"
)

hide_bar() {
    dms ipc call bar hide index "$BAR_INDEX" >/dev/null 2>&1 || true
}

show_bar() {
    dms ipc call bar reveal index "$BAR_INDEX" >/dev/null 2>&1 || true
}

title_in_list() {
    local needle="$1"
    shift
    local title
    for title in "$@"; do
        [[ "$title" == "$needle" ]] && return 0
    done
    return 1
}

set_input_preset() {
    local app_title="$1"
    local preset="Default"

    if title_in_list "$app_title" "${PARADOX_PRESET_TITLES[@]}"; then
        preset="Paradox"
    elif title_in_list "$app_title" "${TOOLBAR_PRESET_TITLES[@]}"; then
        preset="Toolbar"
    fi

    if [[ "$current_preset" == "$preset" ]]; then
        return
    fi

    input-remapper-control --command start --device "Razer Naga Pro" --preset "$preset"
    current_preset="$preset"
    echo "set preset to $preset for title '$app_title'"
}

current_mode=""
current_preset=""

apply_state() {
    local workspace_id="$1"

    if [[ "$workspace_id" == "$HIDE_ID" ]]; then
        if [[ "$current_mode" != "hidden" ]]; then
            hide_bar
            current_mode="hidden"
            echo "hid bar on workspace id $workspace_id"
        fi
    else
        if [[ "$current_mode" != "shown" ]]; then
            show_bar
            current_mode="shown"
            echo "showed bar on workspace id $workspace_id"
        fi
    fi
}

# Apply preset immediately for the currently focused window at startup.
app_title="$(niri msg -j focused-window | jq -r '.title // empty' 2>/dev/null || true)"
set_input_preset "$app_title"

niri msg --json event-stream | while IFS= read -r line; do
    if jq -e 'has("WindowFocusChanged")' >/dev/null 2>&1 <<<"$line"; then
        app_title="$(niri msg -j focused-window | jq -r '.title // empty')"
        set_input_preset "$app_title"
    fi

    workspace_id="$(jq -r '.WorkspaceActivated.id // empty' <<<"$line")"

    [[ -n "$workspace_id" ]] || continue
    apply_state "$workspace_id"
done
