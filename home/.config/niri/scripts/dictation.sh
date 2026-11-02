#!/bin/sh
# hyprwhspr dictation helper for niri.
#   toggle  - start/stop recording (Mod+D); arms Escape while recording
#   escape  - stop recording (bound to Escape only while armed)
#   arm     - add the Escape bind (for testing)
#   disarm  - remove the Escape bind (run at startup)
# Escape is bound via dictation.kdl (included from config.kdl) only while a
# recording is running, so Escape behaves normally the rest of the time.

rt="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/hyprwhspr"
inc="$HOME/.config/niri/dictation.kdl"
hw="$HOME/.local/bin/hyprwhspr"

recording() { [ "$(cat "$rt/recording_status" 2>/dev/null)" = true ]; }

write_inc() { printf '%s\n' "$1" > "$inc.tmp" && mv -f "$inc.tmp" "$inc"; }
arm() {
    write_inc '// Managed by scripts/dictation.sh - armed while hyprwhspr is recording.
binds {
    Escape repeat=false hotkey-overlay-title="Stop dictation" { spawn-sh "$HOME/.config/niri/scripts/dictation.sh escape"; }
}'
}
disarm() { write_inc '// Managed by scripts/dictation.sh - Escape-to-stop is added here while hyprwhspr is recording.'; }

case "$1" in
    toggle)
        if recording; then
            "$hw" record stop
            disarm
        else
            "$hw" record start && arm
        fi
        ;;
    escape)
        if recording; then
            "$hw" record stop
            disarm
        else
            # Stale bind (recording ended some other way): clean up, pass Escape through.
            disarm
            exec wtype -k Escape
        fi
        ;;
    arm) arm ;;
    disarm) disarm ;;
    *) echo "usage: $0 toggle|escape|disarm" >&2; exit 2 ;;
esac
