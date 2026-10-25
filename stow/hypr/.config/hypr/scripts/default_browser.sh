#!/bin/bash

browser_cache="$HOME/.config/hypr/.cache/.browser"
scripts_dir="$HOME/.config/hypr/scripts"

# Создаем папку кэша и файл, если их нет
mkdir -p "$(dirname "$browser_cache")"
[[ ! -f "$browser_cache" ]] && touch "$browser_cache"

# Очищаем старые записи поиска, но СОХРАНЯЕМ строку дефолтного браузера, если она уже есть
current_default=$(grep "default=" "$browser_cache" 2>/dev/null)
echo "$current_default" > "$browser_cache"

# Список известных браузеров для проверки
possible_browsers=(
    "firefox"
    "brave"
    "google-chrome-stable"
    "chromium"
    "opera"
    "vivaldi"
    "zen-browser"
)

# Проверяем, что реально установлено в системе, и пишем в кэш без дубликатов
for browser in "${possible_browsers[@]}"; do
    if command -v "$browser" &>/dev/null; then
        # Пишем в кэш, только если этого браузера там еще нет
        if ! grep -qx "$browser" "$browser_cache"; then
            echo "$browser" >> "$browser_cache"
        fi
    fi
done

# Считаем сколько ВСЕГО реальных браузеров найдено (исключая строку default=)
browsers_num=$(grep -v "default=" "$browser_cache" | grep -v "^$" | wc -l)
default=$(grep "default=" "$browser_cache" | awk -F'=' '{print $2}')

# Если браузеров много, а дефолтный не выбран — открываем окно выбора
if [[ "$browsers_num" -gt 1 && -z "$default" ]]; then
    notify-send "Missing Default Browser" "You need to set a default browser. Opening kitty to set a default browser."
    sleep 2
    kitty --title browser sh -c "$scripts_dir/browser.sh ch"

# Если установлен только ОДИН браузер, и дефолт еще не прописан — ставим его автоматически
elif [[ "$browsers_num" -eq 1 && -z "$default" ]]; then
    existing=$(grep -v "default=" "$browser_cache" | grep -v "^$")
    notify-send "Default browser" "Setting $existing as your default browser."
    sed -i '/default=/d' "$browser_cache"
    echo "default=$existing" >> "$browser_cache"
fi

# Обработка флага сброса
case $1 in
--reset)
    rm -f "$browser_cache"
    notify-send "Reset" "Default browser list has been reset"
    exec "$0"
    ;;
esac
