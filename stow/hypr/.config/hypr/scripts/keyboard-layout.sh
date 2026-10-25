#!/bin/bash

layout=$(hyprctl devices -j | jq -r '.keyboards[] | select(.name == "gaming-kb-gaming-kb") | .active_keymap' | head -1)

case "$layout" in
    "English (US)")
        echo '{"text": "EN", "tooltip": "English (US)"}'
        ;;
    "Russian")
        echo '{"text": "RU", "tooltip": "Russian"}'
        ;;
    *)
        echo "{\"text\": \"?\", \"tooltip\": \"$layout\"}"
        ;;
esac