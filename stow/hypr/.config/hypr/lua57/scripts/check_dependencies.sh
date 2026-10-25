#!/usr/bin/env bash
# Проверка зависимостей для Lua-конфигурации Hyprland

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "🔍 Проверка зависимостей Hyprland Lua-конфига..."
echo

# Критичные зависимости
CRITICAL=(
    "Hyprland:hyprland"
    "Waybar:waybar"
    "Rofi:rofi"
    "Kitty:kitty"
    "Notification Daemon:swaync"
    "Idle Manager:hypridle"
    "Lock Screen:hyprlock"
    "Clipboard:cliphist"
    "Pyprland:pypr"
    "Playerctl:playerctl"
)

# Опциональные зависимости
OPTIONAL=(
    "Gum (для settings.sh):gum"
    "JQ (для wallpaper):jq"
    "Thunar:thunar"
    "Yazi:yazi"
    "CoreCtrl:corectrl"
)

check_command() {
    if command -v "$2" &>/dev/null; then
        echo -e "${GREEN}✓${NC} $1"
        return 0
    else
        echo -e "${RED}✗${NC} $1"
        return 1
    fi
}

echo "=== Критичные зависимости ==="
missing_critical=0
for dep in "${CRITICAL[@]}"; do
    IFS=':' read -r name cmd <<< "$dep"
    check_command "$name" "$cmd" || ((missing_critical++))
done

echo
echo "=== Опциональные зависимости ==="
for dep in "${OPTIONAL[@]}"; do
    IFS=':' read -r name cmd <<< "$dep"
    check_command "$name" "$cmd" || true
done

echo
echo "=== Проверка скриптов ==="
scripts_dir="$HOME/.config/hypr/scripts"
lua_scripts_dir="$HOME/.config/hypr/lua57/scripts"

check_script() {
    if [[ -x "$1" ]]; then
        echo -e "${GREEN}✓${NC} $(basename "$1")"
    else
        echo -e "${YELLOW}!${NC} $(basename "$1") (отсутствует или не исполняемый)"
    fi
}

# Проверяем основные скрипты
for script in "$scripts_dir"/*.sh; do
    [[ -f "$script" ]] && check_script "$script"
done

echo
echo "=== Проверка конфигурации ==="

if [[ -f "$HOME/.cache/wal/colors.json" ]]; then
    echo -e "${GREEN}✓${NC} Pywal colors.json найден"
else
    echo -e "${YELLOW}!${NC} Pywal colors.json не найден (будут использованы fallback цвета)"
fi

# Проверка синтаксиса Lua-конфига
if Hyprland --verify-config -c "$HOME/.config/hypr/hyprland-lua.lua" 2>&1 | grep -q "config ok"; then
    echo -e "${GREEN}✓${NC} Lua-конфигурация валидна"
else
    echo -e "${RED}✗${NC} Lua-конфигурация содержит ошибки"
    missing_critical=$((missing_critical + 1))
fi

echo
if [[ $missing_critical -eq 0 ]]; then
    echo -e "${GREEN}✓ Все критичные зависимости установлены!${NC}"
    exit 0
else
    echo -e "${RED}✗ Отсутствует $missing_critical критичных зависимостей${NC}"
    exit 1
fi
