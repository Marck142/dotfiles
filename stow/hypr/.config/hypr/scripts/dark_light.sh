#!/bin/bash

mode_file="$HOME/.config/hypr/.cache/.current_mode"
next_mode_file="$HOME/.config/hypr/.cache/.next_mode"
scripts_dir="$HOME/.config/hypr/scripts"

# Создаем файлы режимов, если их нет
[[ ! -f "$mode_file" ]] && echo "dark" > "$mode_file"
[[ ! -f "$next_mode_file" ]] && echo "light" > "$next_mode_file"

# Читаем текущий и следующий режим
current_mode=$(cat "$mode_file")
next_mode=$(cat "$next_mode_file")

# ============================================
# НАСТРОЙКИ (подставьте свои пути и темы)
# ============================================

WAYBAR_STYLE="$HOME/.config/waybar/style.css"
GTK_THEME_DARK="Tokyonight-Dark"
GTK_THEME_LIGHT="Tokyonight-Light"

# ============================================
# ПЕРЕКЛЮЧЕНИЕ
# ============================================

if [[ "$next_mode" == "light" ]]; then
    notify-send "Mode" "🔄 Переключение на СВЕТЛУЮ тему..." -t 1500
    
    # Waybar стиль
    if [[ -f "$WAYBAR_STYLE" ]]; then
        sed -i 's/rgba(0, 0, 0, [0-9.]*)/rgba(255, 255, 255, 0.5)/g' "$WAYBAR_STYLE"
    fi
    
    # GTK тема
    if command -v gsettings &> /dev/null; then
        gsettings set org.gnome.desktop.interface gtk-theme "$GTK_THEME_LIGHT"
    fi
    
    # Обновляем файлы режимов
    echo "dark" > "$next_mode_file"
    echo "light" > "$mode_file"
    
elif [[ "$next_mode" == "dark" ]]; then
    notify-send "Mode" "🔄 Переключение на ТЁМНУЮ тему..." -t 1500
    
    # Waybar стиль
    if [[ -f "$WAYBAR_STYLE" ]]; then
        sed -i 's/rgba(255, 255, 255, [0-9.]*)/rgba(0, 0, 0, 0.5)/g' "$WAYBAR_STYLE"
    fi
    
    # GTK тема
    if command -v gsettings &> /dev/null; then
        gsettings set org.gnome.desktop.interface gtk-theme "$GTK_THEME_DARK"
    fi
    
    # Обновляем файлы режимов
    echo "light" > "$next_mode_file"
    echo "dark" > "$mode_file"
fi

# Перезапускаем Waybar для применения стилей
sleep 0.5
killall waybar 2>/dev/null && waybar &

# Перегенерируем цвета (по желанию)
"$scripts_dir/pywal.sh" 2>/dev/null

notify-send "Mode" "✅ Переключение завершено!" -t 1500