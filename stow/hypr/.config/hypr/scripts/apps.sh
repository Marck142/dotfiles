#!/bin/bash

case $1 in
    ds)
        url="https://chat.deepseek.com/a/chat/s/06eaa027-74a7-4d17-a97e-d3f3eea37b6f"
        ;;
    yt)
        url="https://www.youtube.com"
        ;;
    ai)
        url="https://chat.openai.com"
        ;;
    gem)
        url="https://gemini.google.com/app"
        ;;
    ym)
        url="https://music.yandex.ru"
        ;;
    github)
        url="https://github.com"
        ;;
    ps)
        url="https://www.photopea.com/"
        ;;
    kino)
        url="https://hd.kinopoisk.ru/"
        ;;
    porno)
        url="https://rt.pornhub.com/"
        ;;

    *)
        echo "Usage: $0 {fb|yt|ai|wapp|github}"
        exit 1
        ;;
esac

# Define the browsers in the order of preference
browser_cache="$HOME/.config/hypr/.cache/.browser"
browser=$(grep "default" "$browser_cache" | awk -F'=' '{print $2}')

# Loop through the browsers and try to open the URL with the first available one
if [[ ! "$browser" == "firefox" ]]; then
    "$browser" --app="$url"
elif [[ "$browser" == "firefox" || "$browser" == "zen-browser" ]]; then
    "$browser" --new-window "$url"
fi
