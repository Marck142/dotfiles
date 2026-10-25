#!/usr/bin/env sh

NEW_WALL="${1}"     # Сюда Skwd-wall передаст %path%
WALL_TYPE="${2}"    # Сюда Skwd-wall передаст %type%

export cacheDir="$HOME/.config/hypr/.cache"
export thmbDir="${cacheDir}/thumbs"
scripts_dir="$HOME/.config/hypr/scripts"

baseName="$(basename "${NEW_WALL}")"
wallName="${baseName%.*}"

# Записываем имя в кэш
echo "$wallName" > "${cacheDir}/.wallpaper"
mkdir -p "${thmbDir}"
chmod u+w "${thmbDir}"

TARGET_IMG=""

if [ "$WALL_TYPE" = "video" ]; then
    # Для видео-обоев делаем скриншот 1-го кадра
    TARGET_IMG="${cacheDir}/video_frame.png"
    rm -f "$TARGET_IMG"
    ffmpeg -ss 00:00:00 -i "$NEW_WALL" -vframes 1 -q:v 2 "$TARGET_IMG" > /dev/null 2>&1
    ln -sf "$TARGET_IMG" "${cacheDir}/current_wallpaper.png"
else
    # Для обычных картинок
    TARGET_IMG="${NEW_WALL}"
    ln -sf "${NEW_WALL}" "${cacheDir}/current_wallpaper.png"
fi

# ---- ГЛАВНЫЙ ШАГ: Запускаем pywal на картинке или стоп-кадре видео ----
if [ -f "${TARGET_IMG}" ]; then
    # Ключ -q (тихий режим), -t (пропуск смены обоев в tty, т.к. это делает Skwd)
    wal -q -t -i "${TARGET_IMG}"

    # Генерируем эффекты квадратов и блюра из твоего старого wallcache.sh
    [ ! -e "${thmbDir}/${wallName}.sqre" ] && \
        magick "${TARGET_IMG}"[0] -strip -thumbnail 500x500^ -gravity center -extent 500x500 \
        "${thmbDir}/${wallName}.sqre"

    [ ! -e "${thmbDir}/${wallName}.blur" ] && \
        magick "${TARGET_IMG}"[0] -strip -scale 70% -blur 0x10 -resize 100% \
        "${thmbDir}/${wallName}.blur"

    [ ! -e "${thmbDir}/${wallName}.quad" ] && \
        magick "${thmbDir}/${wallName}.sqre" \
        \( -size 500x500 xc:white -fill "rgba(0,0,0,0.7)" \
           -draw "polygon 400,500 500,500 500,0 450,0" \
           -fill black \
           -draw "polygon 500,500 500,0 450,500" \) \
        -alpha Off -compose CopyOpacity -composite \
        "${thmbDir}/${wallName}.png" && \
        mv "${thmbDir}/${wallName}.png" "${thmbDir}/${wallName}.quad"

    rm -f "${cacheDir}/wall.blur" "${cacheDir}/wall.quad"
    cp -r "${thmbDir}/${wallName}.blur" "${cacheDir}/wall.blur"
    cp -r "${thmbDir}/${wallName}.quad" "${cacheDir}/wall.quad"
fi

# Накатываем тему на SDDM
"$scripts_dir/sddm_theme.sh"
