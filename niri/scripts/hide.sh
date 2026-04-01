#!/usr/bin/env bash
set -euo pipefail

HIDE_ID="${1:-1}"
BAR_INDEX="${BAR_INDEX:-0}"

hide_bar() {
    dms ipc call bar hide index "$BAR_INDEX" >/dev/null 2>&1 || true
}

show_bar() {
    dms ipc call bar reveal index "$BAR_INDEX" >/dev/null 2>&1 || true
}

current_mode=""

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

niri msg --json event-stream | while IFS= read -r line; do
    workspace_id="$(
        jq -r '
            .WorkspaceActivated.id // empty
        ' <<<"$line"
    )"

    [[ -n "$workspace_id" ]] || continue
    apply_state "$workspace_id"
done
