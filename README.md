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

Конфиги раскладываются симлинками через GNU Stow (`stow/<приложение>/.config/...`),
уже существующие файлы переносятся в `~/.dotfiles-backup-*`, ничего не удаляется.

## После установки
1. Положите обои в `~/Pictures/Wallpapers` и выполните `wal -i /путь/к/обоям`.
2. Перезагрузитесь, выберите сессию Hyprland.

## Что подправить под себя
- Видеодрайвер, микрокод процессора (`intel-ucode`/`amd-ucode`) и прочее железо в списки не входят.
- Раскладка, мониторы, автозапуск: `~/.config/hypr`.
- Ключ погоды для Waybar: `~/.config/waybar/weather.conf` (`YANDEX_API_KEY`).

## Заметки
- Ссылки на цвета pywal (`~/.cache/wal/...`) перечислены в `wal-links.txt` и создаются `install.sh` под вашего пользователя, пока цветов нет, они «висят», это нормально до первого `wal -i`.
- Фон SDDM и обои не входят в репозиторий.
