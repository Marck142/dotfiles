#!/bin/bash

scripts_dir="$HOME/.config/hypr/scripts"
themes_dir="$HOME/.config/hypr/.cache/colors"
cache_dir="$HOME/.config/hypr/.cache"
wallCache="$cache_dir/.wallpaper"
wallpaper_dir="$HOME/.config/hypr/Wallpaper"

[[ ! -f "$wallCache" ]] && touch "$wallCache"

# Считываем имя текущих обоев из кэша
currentWall=$(cat "$wallCache")

# Собираем все доступные картинки в массив
PICS=($(find ${wallpaper_dir} -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" -o -name "*.gif" \)))

# Если в папке всего одна картинка, то крутить цикл нет смысла — уходим в бесконечность
if [ ${#PICS[@]} -gt 1 ]; then
    while true; do
        # Выбираем случайные обои
        wallpaper=${PICS[ $RANDOM % ${#PICS[@]} ]}
        
        # Получаем их чистое имя (без пути и расширения)
        baseName="$(basename "$wallpaper")"
        wallName=${baseName%.*}
        
        # Если новое имя НЕ совпадает с текущим, выходим из цикла
        if [ "$wallName" != "$currentWall" ]; then
            break
        fi
    done
else
    # Если картинка всего одна, просто берем её
    wallpaper=${PICS[0]}
    baseName="$(basename "$wallpaper")"
    wallName=${baseName%.*}
fi

# Transition config
FPS=60
TYPE="random"
DURATION=1
BEZIER=".43,1.19,1,.4"
SWWW_PARAMS="--transition-fps $FPS --transition-type $TYPE --transition-duration $DURATION --transition-bezier $BEZIER"

awww-daemon &
awww img ${wallpaper} $SWWW_PARAMS

ln -sf "$wallpaper" "$cache_dir/current_wallpaper.png"

# Записываем новые обои в кэш
echo "$wallName" > "$wallCache"

sleep 0.5
"$scripts_dir/wallcache.sh"
"$scripts_dir/pywal.sh"
"$scripts_dir/sddm_theme.sh"