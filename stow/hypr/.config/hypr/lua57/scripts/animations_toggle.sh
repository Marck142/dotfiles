#!/usr/bin/env bash
set -euo pipefail
config_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../configs" && pwd)"
state="$config_dir/state.lua"
# Не вызываем старый скрипт: он редактирует configs/*.conf.
if grep -q 'animations = true' "$state"; then
    sed -i 's/animations = true/animations = false/' "$state"
else
    sed -i 's/animations = false/animations = true/' "$state"
fi
hyprctl reload
