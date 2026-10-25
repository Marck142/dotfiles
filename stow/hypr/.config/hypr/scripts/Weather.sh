#!/usr/bin/env bash
# Универсальный модуль погоды для Waybar.
# Зависимости: curl, jq
#
# Настройка через переменные окружения или файл ~/.config/waybar/weather.conf:
#   WEATHER_PROVIDER=yandex|openmeteo|wttr   (по умолчанию: yandex, если задан ключ, иначе openmeteo)
#   YANDEX_API_KEY=...                       (ключ API Яндекс.Погоды)
#   WEATHER_LAT=55.3467  WEATHER_LON=49.4189 (координаты; если не заданы - определяются по IP)
#   WEATHER_CITY="Нижнекамск"                (необязательно, только для подписи в подсказке)

CONF="${XDG_CONFIG_HOME:-$HOME/.config}/waybar/weather.conf"
[[ -f "$CONF" ]] && source "$CONF"

CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/waybar-weather"
CACHE_FILE="$CACHE_DIR/last.json"
mkdir -p "$CACHE_DIR"

CURL=(curl -s --max-time 10 --retry 2 --retry-delay 1)

# ---------- вывод ----------
emit() { # text alt tooltip
    jq -cn --arg t "$1" --arg a "$2" --arg tip "$3" \
        '{text:$t, alt:$a, tooltip:$tip}' | tee "$CACHE_FILE"
}

fail() {
    # при ошибке показываем последние удачные данные, если они есть
    if [[ -s "$CACHE_FILE" ]]; then
        jq -c '.text += " ⚠"' "$CACHE_FILE"
    else
        jq -cn '{text:"--", alt:"Ошибка", tooltip:"Нет данных о погоде"}'
    fi
    exit 0
}

# ---------- координаты ----------
if [[ -z "$WEATHER_LAT" || -z "$WEATHER_LON" ]]; then
    geo=$("${CURL[@]}" "http://ip-api.com/json/?lang=ru&fields=status,lat,lon,city")
    [[ "$(jq -r '.status' <<<"$geo" 2>/dev/null)" == "success" ]] || fail
    WEATHER_LAT=$(jq -r '.lat' <<<"$geo")
    WEATHER_LON=$(jq -r '.lon' <<<"$geo")
    : "${WEATHER_CITY:=$(jq -r '.city' <<<"$geo")}"
fi

if [[ -z "$WEATHER_PROVIDER" ]]; then
    [[ -n "$YANDEX_API_KEY" ]] && WEATHER_PROVIDER=yandex || WEATHER_PROVIDER=openmeteo
fi

# ---------- вспомогательное ----------
fmt_temp() { # округление и знак
    local t
    t=$(printf '%.0f' "$1" 2>/dev/null) || { echo "$1"; return; }
    (( t > 0 )) && echo "+$t" || echo "$t"
}

wind_dir() { # градусы -> сторона света
    local dirs=(С СВ В ЮВ Ю ЮЗ З СЗ)
    echo "${dirs[$(( ( ${1%.*} + 22 ) % 360 / 45 ))]}"
}

# ---------- провайдеры ----------
# каждый заполняет: TEMP FEELS DESC ICON HUM PRESS WIND

icon_by_key() {
    case "$1" in
        clear)                         ICON="☀️";;
        partly-cloudy)                 ICON="⛅";;
        cloudy)                        ICON="🌥️";;
        overcast)                      ICON="☁️";;
        fog)                           ICON="🌫️";;
        drizzle|light-rain)            ICON="🌦️";;
        rain|moderate-rain|continuous-heavy-rain|heavy-rain|showers) ICON="🌧️";;
        wet-snow|light-snow|snow|snow-showers|hail) ICON="🌨️";;
        thunderstorm*)                 ICON="⛈️";;
        *)                             ICON="🌡️";;
    esac
}

provider_yandex() {
    [[ -n "$YANDEX_API_KEY" ]] || return 1
    local r
    r=$("${CURL[@]}" -H "X-Yandex-Weather-Key: $YANDEX_API_KEY" \
        "https://api.weather.yandex.ru/v2/forecast?lat=$WEATHER_LAT&lon=$WEATHER_LON&lang=ru_RU&limit=1&hours=false&extra=false") || return 1
    jq -e '.fact.temp' <<<"$r" >/dev/null 2>&1 || return 1

    TEMP=$(jq -r '.fact.temp' <<<"$r")
    FEELS=$(jq -r '.fact.feels_like' <<<"$r")
    HUM=$(jq -r '.fact.humidity' <<<"$r")
    PRESS=$(jq -r '.fact.pressure_mm' <<<"$r")
    WIND="$(jq -r '.fact.wind_speed' <<<"$r") м/с, $(jq -r '.fact.wind_dir' <<<"$r" | tr 'a-z' 'A-Z' | sed 's/N/С/g;s/S/Ю/g;s/E/В/g;s/W/З/g')"
    local cond; cond=$(jq -r '.fact.condition' <<<"$r")
    icon_by_key "$cond"
    case "$cond" in
        clear) DESC="Ясно";;
        partly-cloudy) DESC="Малооблачно";;
        cloudy) DESC="Облачно с прояснениями";;
        overcast) DESC="Пасмурно";;
        drizzle) DESC="Морось";;
        light-rain) DESC="Небольшой дождь";;
        rain|moderate-rain) DESC="Дождь";;
        heavy-rain|continuous-heavy-rain) DESC="Сильный дождь";;
        showers) DESC="Ливень";;
        wet-snow) DESC="Дождь со снегом";;
        light-snow) DESC="Небольшой снег";;
        snow) DESC="Снег";;
        snow-showers) DESC="Снегопад";;
        hail) DESC="Град";;
        thunderstorm) DESC="Гроза";;
        thunderstorm-with-rain) DESC="Дождь с грозой";;
        thunderstorm-with-hail) DESC="Гроза с градом";;
        *) DESC="$cond";;
    esac
}

provider_openmeteo() {
    local r
    r=$("${CURL[@]}" "https://api.open-meteo.com/v1/forecast?latitude=$WEATHER_LAT&longitude=$WEATHER_LON&current=temperature_2m,apparent_temperature,relative_humidity_2m,surface_pressure,weather_code,wind_speed_10m,wind_direction_10m&wind_speed_unit=ms&timezone=auto") || return 1
    jq -e '.current.temperature_2m' <<<"$r" >/dev/null 2>&1 || return 1

    TEMP=$(jq -r '.current.temperature_2m' <<<"$r")
    FEELS=$(jq -r '.current.apparent_temperature' <<<"$r")
    HUM=$(jq -r '.current.relative_humidity_2m' <<<"$r")
    PRESS=$(jq -r '(.current.surface_pressure * 0.75006) | round' <<<"$r")
    WIND="$(jq -r '.current.wind_speed_10m' <<<"$r") м/с, $(wind_dir "$(jq -r '.current.wind_direction_10m' <<<"$r")")"
    local code; code=$(jq -r '.current.weather_code' <<<"$r")
    case $code in
        0)        DESC="Ясно";               ICON="☀️";;
        1)        DESC="Преимущественно ясно"; ICON="🌤️";;
        2)        DESC="Переменная облачность"; ICON="⛅";;
        3)        DESC="Пасмурно";           ICON="☁️";;
        45|48)    DESC="Туман";              ICON="🌫️";;
        51|53|55|56|57) DESC="Морось";       ICON="🌦️";;
        61|63|65|66|67) DESC="Дождь";        ICON="🌧️";;
        71|73|75|77)    DESC="Снег";         ICON="🌨️";;
        80|81|82) DESC="Ливень";             ICON="🌧️";;
        85|86)    DESC="Снегопад";           ICON="🌨️";;
        95|96|99) DESC="Гроза";              ICON="⛈️";;
        *)        DESC="Нет данных";         ICON="🌡️";;
    esac
}

provider_wttr() {
    local r
    r=$("${CURL[@]}" "https://wttr.in/$WEATHER_LAT,$WEATHER_LON?format=j1&lang=ru") || return 1
    jq -e '.current_condition[0].temp_C' <<<"$r" >/dev/null 2>&1 || return 1

    TEMP=$(jq -r '.current_condition[0].temp_C' <<<"$r")
    FEELS=$(jq -r '.current_condition[0].FeelsLikeC' <<<"$r")
    HUM=$(jq -r '.current_condition[0].humidity' <<<"$r")
    PRESS=$(jq -r '(.current_condition[0].pressure | tonumber * 0.75006) | round' <<<"$r")
    WIND="$(jq -r '(.current_condition[0].windspeedKmph | tonumber / 3.6 * 10 | round / 10)' <<<"$r") м/с, $(jq -r '.current_condition[0].winddir16Point' <<<"$r")"
    DESC=$(jq -r '.current_condition[0].lang_ru[0].value // .current_condition[0].weatherDesc[0].value' <<<"$r")
    ICON="🌡️"
}

# ---------- запуск: выбранный провайдер, затем запасные ----------
order=("$WEATHER_PROVIDER")
for p in yandex openmeteo wttr; do
    [[ "$p" != "$WEATHER_PROVIDER" ]] && order+=("$p")
done

ok=0
for p in "${order[@]}"; do
    if "provider_$p" 2>/dev/null; then ok=1; USED="$p"; break; fi
done
(( ok )) || fail

T=$(fmt_temp "$TEMP")
F=$(fmt_temp "$FEELS")

tooltip="${WEATHER_CITY:+$WEATHER_CITY\n}$DESC, $T°C (ощущается как $F°C)
Ветер: $WIND
Влажность: $HUM%
Давление: $PRESS мм рт. ст."

emit "$T°C" "$DESC" "$tooltip"