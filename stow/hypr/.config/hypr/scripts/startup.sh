#!/bin/bash

scripts_dir="$HOME/.config/hypr/scripts"
wallpaper="$HOME/.config/hypr/.cache/current_wallpaper.png"

# if openbangla keyboard is installed, the
if [[ -d "/usr/share/openbangla-keyboard" ]]; then
    fcitx5 &> /dev/null
fi


"$scripts_dir/notification.sh" sys
if [[ -f "$wallpaper" ]]; then
    "$scripts_dir/wallcache.sh"
    "$scripts_dir/pywal.sh"
fi
pgrep -f "^/bin/bash $scripts_dir/system.sh" >/dev/null || "$scripts_dir/system.sh" run &


#_____ setup monitor ( updated teh monitor.conf for the high resolution and higher refresh rate )

# monitor_setting=$(cat $monitor_config | grep "monitor")
# monitor_icon="$HOME/.config/hypr/icons/monitor.png"
# if [[ "$monitor_setting" == "monitor=,preferred,auto,auto" ]]; then
#     notify-send -i "$monitor_icon" "Monitor Setup" "A popup for your monitor configuration will appear within 5 seconds." && sleep 5
#     kitty --title monitor sh -c "$scripts_dir/monitor.sh"
# fi
#
# sleep 3

"$scripts_dir/default_browser.sh"
