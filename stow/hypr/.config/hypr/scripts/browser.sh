#!/bin/bash

browser_cache="$HOME/.config/hypr/.cache/.browser"
scripts_dir="$HOME/.config/hypr/scripts"

# Читаем только реальные имена браузеров из кэша (исключая строку дефолта и пустые строки)
browsers=($(grep -v "default=" "$browser_cache" | grep -v "^$"))
browser_num="${#browsers[@]}" # Безопасный подсчет элементов массива в Bash

# Вытаскиваем текущий дефолтный браузер
default=$(grep "default=" "$browser_cache" | awk -F'=' '{print $2}')

choose_default() {
    if [[ "$browser_num" -gt 1 && -z "$default" ]]; then
        printf "[ Missing Default Browser ]\n==> You don't have a default browser. Choose which browser you want to set as default.\n\n"

        choose=("${browsers[@]}" "Reset")
        # Prompt user to choose a browser
        choice=$(gum choose --limit=1 "${choose[@]}")

        # Check if a valid choice was made
        if [[ "$choice" == "Reset" ]]; then
            sed -i "/^default=/d" "$browser_cache"
            notify-send "Default Browser Reset" "Default browser has been reset"
        elif [[ -n "$choice" ]]; then
            if grep -q "^default=" "$browser_cache"; then
                sed -i "s|^default=.*|default=$choice|" "$browser_cache"
                notify-send "Default Browser Set" "Default browser updated to: $choice"
            else
                echo "default=$choice" >> "$browser_cache"
                notify-send "Default Browser Set" "Default browser set to: $choice"
            fi
        else
            notify-send "Skipped" "No browser selected. Default browser not set."
        fi

    elif [[ "$browser_num" -eq 1 && -z "$default" ]]; then
        # Если браузер один, берем именно его из массива
        echo "default=${browsers[0]}" >> "$browser_cache"
    fi
}

open_browser() {
    # Если дефолтный браузер почему-то не установлен, запускаем первый скрипт для его поиска
    if [[ -z "$default" ]]; then
        "$scripts_dir/default_browser.sh"
        # Перечитываем дефолт после работы первого скрипта
        default=$(grep "default=" "$browser_cache" | awk -F'=' '{print $2}')
    fi

    # ХАРДКОД ФЛАГОВ ЗАПУСКА ПОД WAYLAND И HYPRLAND
    case "$default" in
        "firefox"|"zen-browser"|"floorp")
            # Браузеры на движке Gecko (Firefox) работают на Wayland нативно без костылей
            "$default" "$@"
            ;;
        "brave"|"google-chrome-stable"|"chromium"|"vivaldi"|"opera")
            # Браузеры на движке Chromium требуют флагов для Wayland и аппаратного ускорения
            # Мы берем конфиг флагов из ~/.config/brave-flags.conf (если он есть) или передаем базовые
            if [[ "$default" == "brave" && -f "$HOME/.config/brave-flags.conf" ]]; then
                "$default" $(cat "$HOME/.config/brave-flags.conf" | grep -v '^#') "$@"
            else
                "$default" --ozone-platform-hint=auto --ozone-platform=wayland --enable-wayland-ime --enable-gpu-rasterization "$@"
            fi
            ;;
        *)
            # Фолбэк на случай, если имя необычное — запускаем как есть
            "$default" "$@"
            ;;
    esac
}

case $1 in
    ch)
        choose_default
        ;;
    op)
        open_browser "${@:2}" # Пробрасываем все остальные аргументы (например, ссылки)
        ;;
esac
