#!/bin/bash

#-----------------------------------------#
#          Memory Usage Notify            #
#-----------------------------------------#
notified=false

while true; do
    # Считываем total и used за ОДИН вызов free -m
    read total_mem used_mem < <(free -m | awk 'NR==2 {print $2, $3}')
    
    # Считаем 80% порог
    eighty_percent=$(( total_mem * 80 / 100 ))

    if [[ "$used_mem" -ge "$eighty_percent" ]]; then
        if [[ "$notified" == false ]]; then
            notify-send -u "critical" -i "$HOME/.config/hypr/icons/warning.png" \
            "Warning!" "80% of memory used: $used_mem MB in use"
            notified=true
        fi
    else
        notified=false
    fi

    # Теперь реально спим 60 секунд, как и обещал комментарий!
    sleep 60
done
