#!/usr/bin/env bash
set -euo pipefail
config_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../configs" && pwd)"
state="$config_dir/state.lua"
# Не вызываем старый скрипт: он редактирует configs/*.conf.
if grep -q 'animations = true' "$state"; then
    sed -i 's/animations = true/animations = false/' "$state"
    # Config reload alone does not unload plugins already in the compositor.
    plugin_dir="/var/cache/hyprpm/${USER:?USER is not set}"
    loaded="$(hyprctl -j plugin list)"
    for entry in \
        'hyprfocus:hyprland-plugins/hyprfocus.so' \
        'dynamic-cursors:dynamic-cursors/dynamic-cursors.so' \
        'omarchy-fx:omarchy-fx/omarchy-fx.so' \
        'hyprglass:HyprGlass/hyprglass.so'; do
        name=${entry%%:*}
        path="$plugin_dir/${entry#*:}"
        if jq -e --arg name "$name" 'any(.[]; .name == $name)' <<< "$loaded" >/dev/null; then
            hyprctl plugin unload "$path"
        fi
    done
else
    sed -i 's/animations = false/animations = true/' "$state"
fi
hyprctl reload
