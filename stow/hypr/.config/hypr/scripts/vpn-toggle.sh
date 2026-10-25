#!/bin/bash

INTERFACE="awg0"

# Функция для принудительного обновления Waybar
update_waybar() {
    pkill -SIGRTMIN+8 waybar
}

# Если скрипт запущен с флагом --status (для вывода в Waybar)
if [ "$1" = "--status" ]; then
    if ip link show "$INTERFACE" > /dev/null 2>&1; then
        echo '{"text": "", "class": "connected"}'
    else
        echo '{"text": "", "class": "disconnected"}'
    fi
    exit 0
fi

# Основная логика переключения (on-click)
if ip link show "$INTERFACE" > /dev/null 2>&1; then
    sudo awg-quick down "$INTERFACE"
    notify-send -a "VPN" -i "network-vpn-off" "AmneziaWG" "Соединение разоврвано"
else
    sudo awg-quick up "$INTERFACE"
    if [ $? -eq 0 ]; then
        notify-send -a "VPN" -i "network-vpn" "AmneziaWG" "Соединение установлено"
    else
        notify-send -a "VPN" -i "dialog-error" "AmneziaWG" "Ошибка подключения"
    fi
fi

# Обновляем иконку сразу после переключения
update_waybar
