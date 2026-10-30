# dotfiles — Hyprland на Arch Linux

Мои конфиги: Hyprland (Lua), Waybar, Rofi, SwayNC, Kitty, Fish + Starship, pywal, SDDM, GRUB.
*My Hyprland rice for Arch Linux: configs + a one-shot dependency installer.*

<!-- Вставьте сюда скриншот: ![screenshot](screenshot.png) -->

## Установка

Нужна свежая установка Arch Linux (например, через `archinstall`) и обычный пользователь с sudo.

```bash
sudo pacman -S --needed git
git clone https://github.com/ВАШ_ЛОГИН/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh --dry-run      # посмотреть, что будет сделано
./install.sh                # пакеты (pacman + AUR) и раскладка конфигов
```

Опции: `--no-pkgs`, `--no-aur`, `--no-links`, `--system` (системные файлы из `system/`: тема SDDM и GRUB).

Конфиги из `stow/<приложение>/` и `copy/` копируются в домашнюю папку.
Заменяемые файлы и ссылки переносятся в `~/.dotfiles-backup-*`.
Неразрешимые исходные ссылки пропускаются с предупреждением.

## После установки
1. Положите обои в `~/Pictures/Wallpapers`, выберите их и запустите `~/.config/hypr/scripts/pywal.sh` для обновления цветов.
2. Перезагрузитесь, выберите сессию Hyprland. Во время установки также ставятся и включаются плагины `hyprfocus`, `dynamic-cursors` и `omarchy-fx` через `hyprpm`.

## Что подправить под себя
- Видеодрайвер, микрокод процессора (`intel-ucode`/`amd-ucode`) и прочее железо в списки не входят.
- Раскладка, мониторы, автозапуск: `~/.config/hypr`.
- Ключ погоды для Waybar: `~/.config/waybar/weather.conf` (`YANDEX_API_KEY`).

## Заметки
- Цвета pywal копируются скриптом `pywal.sh` после генерации, поэтому повторно запускайте его при смене палитры.
- Фон SDDM и обои не входят в репозиторий.
- После обновления Hyprland повторите `hyprpm update`, чтобы пересобрать плагины под новый ABI.
