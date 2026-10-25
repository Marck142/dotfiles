#!/bin/bash

display() {
    cat << EOF
            ╔═╗┬ ┬┌─┐┌┐┌┌─┐┌─┐  ╔═╗┌─┐┌┬┐┌┬┐┬┌┐┌┌─┐┌─┐            
            ║  ├─┤├─┤││││ ┬├┤   ╚═╗├┤  │  │ │││││ ┬└─┐            
────────────╚═╝┴ ┴┴ ┴┘└┘└─┘└─┘  ╚═╝└─┘ ┴  ┴ ┴┘└┘└─┘└─┘────────────
EOF
}

# Скрипт для настройки ширины рамки и скругления окон
setting="$HOME/.config/hypr/configs/configs.conf"
rofiVars="$HOME/.config/rofi/rofi-vars.rasi"
dunst="$HOME/.config/dunst/dunstrc"

# Функция gum для выбора нескольких настроек
display
printf "\n  => Выберите настройки для изменения\n  -> Выбирайте клавишей ПРОБЕЛ\n"
echo
_hyprland_choice=$(gum choose \
    --header "Выберите настройки:" \
    --header.foreground "#d4d8d8" \
    --no-limit \
    --cursor.foreground "#d4d8d8" \
    "размер рамки" \
    "скругление" \
    "внутренний отступ" \
    "внешний отступ" \
    "размытие" \
    "прозрачность" \
    "тень" \
    "отмена"
)

# Преобразуем строку с переносами в массив
IFS=$'\n' read -rd '' -a primary_choice <<<"$_hyprland_choice"

# Выход если выбрана отмена
if [[ -n "$_hyprland_choice" && "${primary_choice[*]}" =~ "отмена" ]]; then
    exit 0
fi

# Обрабатываем каждый выбранный пункт
for user_choice in "${primary_choice[@]}"; do
    clear
    case "$user_choice" in
    "размер рамки")
        printf "\n[ <> ]\nНастройка размера рамки...\n\n"
        borderSize=$(gum input --placeholder "Введите ширину рамки...")
        while ! [[ "$borderSize" =~ ^[0-9]+$ ]]; do
            printf "Неверный ввод. Пожалуйста, введите число.\n"
            borderSize=$(gum input --placeholder "Введите ширину рамки...")
        done
        sed -i "s/\$border = .*/\\\$border = $borderSize/g" "$setting"
        sed -i "s/frame_width = .*/frame_width = $borderSize/g" "$dunst"
        sed -i "s/border-size: .*/border-size: ${borderSize}px;/g" "$rofiVars"
        ;;
    "скругление")
        printf "\n[ <> ]\nНастройка скругления рамки...\n\n"
        rounding=$(gum input --placeholder "Введите радиус скругления...")
        while ! [[ "$rounding" =~ ^[0-9]+$ ]]; do
            printf "Неверный ввод. Пожалуйста, введите число.\n"
            rounding=$(gum input --placeholder "Введите радиус скругления...")
        done
        sed -i 's/\$rounding = .*/$rounding = '"$rounding"'/g' "$setting"
        sed -i "s/radius: .*/radius: ${rounding}px;/g" "$rofiVars"
        sed -i "s/radius-second: .*/radius-second: $((rounding / 2))px;/g" "$rofiVars"
        sed -i "s/^[[:space:]]*corner_radius[[:space:]]*= .*/corner_radius = $((rounding / 2))/g" "$dunst"
        ;;
    "внутренний отступ")
        printf "\n[ <> ]\nНастройка внутреннего отступа...\n\n"
        gaps_in=$(gum input --placeholder "Введите внутренний отступ...")
        while ! [[ "$gaps_in" =~ ^[0-9]+$ ]]; do
            printf "Неверный ввод. Пожалуйста, введите число.\n"
            gaps_in=$(gum input --placeholder "Введите внутренний отступ...")
        done
        sed -i "s/\$inner_gap = .*/\\\$inner_gap = $gaps_in/g" "$setting"
        ;;
    "внешний отступ")
        printf "\n[ <> ]\nНастройка внешнего отступа...\n\n"
        gaps_out=$(gum input --placeholder "Введите внешний отступ...")
        while ! [[ "$gaps_out" =~ ^[0-9]+$ ]]; do
            printf "Неверный ввод. Пожалуйста, введите число.\n"
            gaps_out=$(gum input --placeholder "Введите внешний отступ...")
        done
        sed -i "s/\$outer_gap = .*/\\\$outer_gap = $gaps_out/g" "$setting"
        ;;
    "размытие")
        printf "\n[ <> ]\nНастройка размытия...\n\n"
        _blur_size=$(gum input --placeholder "Введите размер размытия...")
        while ! [[ "$_blur_size" =~ ^[0-9]+$ ]]; do
            printf "Неверный ввод. Пожалуйста, введите число.\n"
            _blur_size=$(gum input --placeholder "Введите размер размытия...")
        done
            _blur_passes=$(gum input --placeholder "Введите количество проходов размытия...")
        while ! [[ "$_blur_passes" =~ ^[0-9]+$ ]]; do
            printf "Неверный ввод. Пожалуйста, введите число.\n"
            _blur_passes=$(gum input --placeholder "Введите количество проходов размытия...")
        done
        sed -i "s/\$blur_size = .*/\\\$blur_size = $_blur_size/g" "$setting"
        sed -i "s/\$blur_passes = .*/\\\$blur_passes = $_blur_passes/g" "$setting"
        ;;
    "прозрачность")
        printf "\n[ <> ]\nНастройка прозрачности...\n\n"
        _act_op=$(gum input --placeholder "Введите прозрачность активного окна (например: 0.9)...")
        while ! [[ "$_act_op" =~ ^[0-9]+(\.[0-9]+)?$ ]]; do
            printf "Неверный ввод. Пожалуйста, введите число.\n"
            _act_op=$(gum input --placeholder "Введите прозрачность активного окна (например: 0.9)...")
        done
            _inact_op=$(gum input --placeholder "Введите прозрачность неактивного окна (например: 0.9)...")
        while ! [[ "$_inact_op" =~ ^[0-9]+(\.[0-9]+)?$ ]]; do
            printf "Неверный ввод. Пожалуйста, введите число.\n"
            _inact_op=$(gum input --placeholder "Введите прозрачность неактивного окна (например: 0.9)...")
        done
        sed -i "s/\$opacity_act = .*/\\\$opacity_act = $_act_op/g" "$setting"
        sed -i "s/\$opacity_deact = .*/\\\$opacity_deact = $_inact_op/g" "$setting"
        ;;
    "тень")
        printf "\n[ <> ]\nНастройка дальности тени (0 — без тени)...\n\n"
        _shd_rng=$(gum input --placeholder "Введите дальность тени...")
        while ! [[ "$_shd_rng" =~ ^[0-9]+(\.[0-9]+)?$ ]]; do
            printf "Неверный ввод. Пожалуйста, введите число.\n"
            _shd_rng=$(gum input --placeholder "Введите дальность тени...")
        done
        sed -i "s/\$shadow_range = .*/\\\$shadow_range = $_shd_rng/g" "$setting"
        ;;
    *)
        echo "Неизвестный выбор: $user_choice"
        ;;
    esac
done

# Перезагружаем Hyprland
printf "\n[ ** ] Перезагрузка конфигурации Hyprland...\n" && sleep 1
killall dunst
dunst &
hyprctl reload