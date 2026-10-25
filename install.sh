#!/usr/bin/env bash
# Установка пакетов и конфигов на свежий Arch Linux. Запускать обычным пользователем (не root).
#   ./install.sh               пакеты (pacman + AUR) и раскладка конфигов
#   ./install.sh --dry-run     только показать, что будет сделано
#   ./install.sh --no-pkgs     без установки пакетов (только конфиги)
#   ./install.sh --no-aur      без AUR
#   ./install.sh --no-links    без раскладки конфигов
#   ./install.sh --system      ещё и системные файлы из system/ (/etc, /usr, /boot; старые копируются с суффиксом ~)
set -uo pipefail
cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"

DRY=0; PKGS=1; AUR=1; LINKS=1; SYSTEM=0; FAILED=()
for a in "$@"; do
    case "$a" in
        --dry-run) DRY=1 ;; --no-pkgs) PKGS=0 ;; --no-aur) AUR=0 ;; --no-links) LINKS=0 ;; --system) SYSTEM=1 ;;
        -h|--help) sed -n '2,9p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
        *) echo "Неизвестная опция: $a"; exit 1 ;;
    esac
done

log()  { printf '\n\033[1;32m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m[!]\033[0m %s\n' "$*" >&2; }
run()  { if ((DRY)); then echo "  + $*"; else "$@"; fi; }
list() { [[ -f "$1" ]] && sed 's/#.*//' "$1" | tr -s ' \t' '\n' | grep . || true; }

[[ $EUID -ne 0 ]] || { warn "Не запускайте от root: скрипт сам вызовет sudo."; exit 1; }
command -v pacman >/dev/null || { warn "Нужен Arch Linux (pacman не найден)."; exit 1; }
if ((!DRY)); then
    sudo -v || exit 1
    while true; do sudo -n true; sleep 50; kill -0 "$$" 2>/dev/null || exit; done 2>/dev/null &
fi

install_native() {
    log "Пакеты из официальных репозиториев"
    mapfile -t L < <(list packages/pacman.txt)
    if ! run sudo pacman -Syu --needed --noconfirm "${L[@]}"; then
        warn "Общая установка не прошла, ставлю по одному"
        for p in "${L[@]}"; do run sudo pacman -S --needed --noconfirm "$p" || FAILED+=("pacman: $p"); done
    fi
}

install_aur() {
    log "Пакеты из AUR"
    if ! command -v yay >/dev/null; then
        if ((DRY)); then echo "  + yay-bin: git clone + makepkg -si"
        else
            local t; t="$(mktemp -d)"
            { git clone --depth 1 https://aur.archlinux.org/yay-bin.git "$t/yay-bin" && (cd "$t/yay-bin" && makepkg -si --noconfirm); } || { FAILED+=("yay"); return; }
        fi
    fi
    while read -r p; do run yay -S --needed --noconfirm "$p" || FAILED+=("aur: $p"); done < <(list packages/aur.txt)
}

link_configs() {
    log "Раскладка конфигов (stow)"
    command -v stow >/dev/null || { FAILED+=("stow не установлен"); return; }
    local bak="$HOME/.dotfiles-backup-$(date +%Y%m%d-%H%M%S)" p f
    for p in stow/*/; do
        p="$(basename "$p")"
        # конфликтующие файлы переносим в резервную папку, а не удаляем
        while IFS= read -r f; do
            [[ -n "$f" && ( -e "$HOME/$f" || -L "$HOME/$f" ) ]] || continue
            run mkdir -p "$bak/$(dirname "$f")"; run mv "$HOME/$f" "$bak/$f"
        done < <(stow -d stow -t "$HOME" -n "$p" 2>&1 | sed -n -e 's/.*over existing target \(.*\) since .*/\1/p' -e 's/.*existing target [^:]*: //p' | sed 's/ => .*//')
        run stow -d stow -t "$HOME" -R "$p" || FAILED+=("stow: $p")
    done
    # файлы, которые приложения переписывают целиком (симлинк бы сломался): копируем, ничего не затирая
    [[ -d copy ]] && run cp -an copy/. "$HOME/"
    [[ -d "$bak" ]] && echo "  Заменённые файлы сохранены в $bak"
}

link_wal() {
    # ссылки на цвета pywal: в репозитории их нет (они указывали бы на /home/<чужой пользователь>), создаём под вас
    [[ -f wal-links.txt ]] || return 0
    log "Ссылки на цвета pywal"
    local l t
    while read -r l t; do
        [[ -z "$l" || "$l" == \#* ]] && continue
        run mkdir -p "$(dirname "$HOME/$l")"; run ln -sfn "$HOME/$t" "$HOME/$l"
    done < wal-links.txt
}

install_system() {
    log "Системные файлы из system/"
    [[ -d system ]] || { warn "Нет папки system/"; return; }
    (cd system && find . -type f | sed 's|^\.||')
    read -rp "Скопировать эти файлы в систему (старые версии сохранятся как файл~)? [y/N] " r
    [[ "$r" == [yY]* ]] || return
    run sudo cp -rT --backup=simple system /
    # тема GRUB: подключаем, если ещё не задана
    if command -v grub-mkconfig >/dev/null && compgen -G "/boot/grub/themes/*/theme.txt" >/dev/null \
            && ! grep -q '^GRUB_THEME=' /etc/default/grub; then
        local t; t="$(ls /boot/grub/themes/*/theme.txt | head -1)"
        run sudo sh -c "echo 'GRUB_THEME=\"$t\"' >> /etc/default/grub"
        run sudo grub-mkconfig -o /boot/grub/grub.cfg
    fi
}

enable_services() {
    log "Службы и оболочка"
    for s in NetworkManager sddm; do
        systemctl list-unit-files "$s.service" >/dev/null 2>&1 && run sudo systemctl enable "$s.service" || true
    done
    run sudo systemctl --global enable pipewire.socket pipewire-pulse.socket wireplumber.service
    if command -v fish >/dev/null && [[ "$SHELL" != *fish ]]; then run chsh -s "$(command -v fish)"; fi
}

((PKGS))  && install_native
((PKGS && AUR)) && install_aur
((LINKS)) && { link_configs; link_wal; }
((SYSTEM)) && install_system
((PKGS))  && enable_services

log "Готово"
if ((${#FAILED[@]})); then
    warn "Не удалось выполнить:"; printf '   - %s\n' "${FAILED[@]}"
else
    echo "Ошибок нет."
fi
cat <<'MSG'

Дальше:
  1. Положите обои в ~/Pictures/Wallpapers и один раз выполните:  wal -i /путь/к/обоям
  2. Перезагрузитесь и на экране входа выберите сессию Hyprland.
  3. Конфликтовавшие со ссылками старые файлы лежат в ~/.dotfiles-backup-*
MSG
