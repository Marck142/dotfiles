#!/usr/bin/env bash
# Установка пакетов и конфигов на свежий Arch Linux. Запускать обычным пользователем (не root).
#   ./install.sh               пакеты (pacman + AUR) и раскладка конфигов
#   ./install.sh --dry-run     только показать, что будет сделано
#   ./install.sh --no-pkgs     без установки пакетов (только конфиги)
#   ./install.sh --no-aur      без AUR
#   ./install.sh --no-links    без копирования конфигов
#   ./install.sh --system      ещё и системные файлы из system/ (/etc, /usr, /boot; старые сохраняются)
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
if ((PKGS)); then command -v pacman >/dev/null || { warn "Нужен Arch Linux (pacman не найден)."; exit 1; }; fi
if ((!DRY && (PKGS || SYSTEM))); then
    sudo -v || exit 1
    while true; do sudo -n true; sleep 50; kill -0 "$$" 2>/dev/null || exit; done 2>/dev/null &
fi

install_native() {
    log "Пакеты из официальных репозиториев"
    mapfile -t L < <(list packages/pacman.txt)
    if ! run sudo pacman -Syu --needed --noconfirm "${L[@]}"; then
        warn "Обновление или установка пакетов не удались; повторите после устранения ошибки."
        FAILED+=("pacman: обновление и установка пакетов")
    fi
}

install_aur() {
    log "Пакеты из AUR"
    if ! command -v yay >/dev/null; then
        if ((DRY)); then echo "  + yay-bin: git clone + makepkg -si"
        else
            local t; t="$(mktemp -d)"
            { git clone --depth 1 https://aur.archlinux.org/yay-bin.git "$t/yay-bin" && (cd "$t/yay-bin" && makepkg -si --noconfirm); } || { rm -rf "$t"; FAILED+=("yay"); return; }
            rm -rf "$t"
        fi
    fi
    while read -r p; do run yay -S --needed --noconfirm "$p" || FAILED+=("aur: $p"); done < <(list packages/aur.txt)
}

install_hypr_plugins() {
    log "Плагины Hyprland"
    if ((DRY)); then
        cat <<'EOF'
  + hyprpm update
  + hyprpm add https://github.com/hyprwm/hyprland-plugins
  + hyprpm add https://github.com/VirtCode/hypr-dynamic-cursors
  + hyprpm add https://github.com/Marck142/omarchy-fx
  + hyprpm add https://github.com/hyprnux/hyprglass
  + hyprpm enable hyprfocus dynamic-cursors omarchy-fx hyprglass
EOF
        return
    fi
    command -v hyprpm >/dev/null || { FAILED+=("hyprpm не установлен"); return; }

    hyprpm update || { warn "hyprpm update завершился с ошибкой; проверьте вывод сборки плагинов."; FAILED+=("hyprpm: обновление плагинов или заголовков"); }

    local repo
    for repo in \
        https://github.com/hyprwm/hyprland-plugins \
        https://github.com/VirtCode/hypr-dynamic-cursors \
        https://github.com/Marck142/omarchy-fx \
        https://github.com/hyprnux/hyprglass; do
        printf 'Y\n' | hyprpm add "$repo" || true
    done

    for plugin in hyprfocus dynamic-cursors omarchy-fx hyprglass; do
        hyprpm enable "$plugin" || FAILED+=("hyprpm enable: $plugin")
    done
    hyprpm update || FAILED+=("hyprpm: сборка плагинов")
    [[ -n ${HYPRLAND_INSTANCE_SIGNATURE:-} ]] && hyprpm reload || true
}

copy_configs() {
    log "Копирование конфигов"
    local bak="$HOME/.dotfiles-backup-$(date +%Y%m%d-%H%M%S)-$$" root src rel dst parent part current actual
    local -a parts
    for root in stow/*/ copy/; do
        [[ -d "$root" ]] || continue
        while IFS= read -r -d '' src; do
            rel=${src#"$root"}; dst="$HOME/$rel"; actual=$src
            [[ "$rel" == .config/waybar/config && -L "$src" ]] && actual="${root}.config/waybar/configs/minimal-bottom"
            if [[ ! -e "$actual" ]]; then
                warn "Пропущена неразрешимая ссылка: $src"; continue
            fi
            parent=${rel%/*}; [[ "$parent" == "$rel" ]] && parent=""
            current=""
            IFS=/ read -r -a parts <<< "$parent"
            for part in "${parts[@]}"; do
                [[ -n "$part" ]] || continue
                current="${current:+$current/}$part"
                if [[ -L "$HOME/$current" || ( -e "$HOME/$current" && ! -d "$HOME/$current" ) ]]; then
                    run mkdir -p "$bak/$(dirname "$current")" && run mv "$HOME/$current" "$bak/$current" || { FAILED+=("backup: $current"); continue 2; }
                fi
                run mkdir -p "$HOME/$current" || { FAILED+=("каталог: $current"); continue 2; }
            done
            if [[ -e "$dst" || -L "$dst" ]]; then
                run mkdir -p "$bak/$(dirname "$rel")" && run mv "$dst" "$bak/$rel" || { FAILED+=("backup: $rel"); continue; }
            fi
            run cp -L -R --preserve=mode,timestamps "$actual" "$dst" || FAILED+=("копирование: $rel")
        done < <(find "$root" -mindepth 1 \( -type f -o -type l \) -print0)
    done
    [[ -d "$bak" ]] && echo "  Заменённые файлы сохранены в $bak"
    return 0
}

install_system() {
    log "Системные файлы из system/"
    [[ -d system ]] || { warn "Нет папки system/"; FAILED+=("нет system/"); return 1; }
    (cd system && find . -type f | sed 's|^\.||')
    if ((!DRY)); then
        read -rp "Скопировать эти файлы в систему (старые версии сохранятся с номером)? [y/N] " r
        [[ "$r" == [yY]* ]] || return 1
    fi
    run sudo cp -rT --backup=numbered system / || { FAILED+=("системные файлы"); return 1; }
    # тема GRUB: подключаем, если ещё не задана
    if command -v grub-mkconfig >/dev/null && compgen -G "/boot/grub/themes/*/theme.txt" >/dev/null \
            && ! grep -q '^GRUB_THEME=' /etc/default/grub; then
        local t; t="$(ls /boot/grub/themes/*/theme.txt | head -1)"
        run sudo sh -c "echo 'GRUB_THEME=\"$t\"' >> /etc/default/grub"
        run sudo grub-mkconfig -o /boot/grub/grub.cfg
    fi
}

install_sddm_sudoers() {
    log "Правила sudoers для SDDM-темы"
    local rule="/etc/sudoers.d/sddm-theme"
    local user="${SUDO_USER:-$USER}"
    local theme="/usr/share/sddm/themes/silent/configs/default-left.conf"
    local bg="/usr/share/sddm/themes/silent/backgrounds/sddm_current_bg.png"
    local cache="$HOME/.config/hypr/.cache"

    if ((DRY)); then
        echo "  + проверить и установить $rule"
        return 0
    fi

    # файлы, к которым будут применяться правила, должны существовать
    if ((!DRY)) && [[ ! -f "$theme" ]]; then
        warn "Не найден $theme — правило для sed не ставлю."
        FAILED+=("sudoers: $theme отсутствует")
        return
    fi

    local t; t="$(mktemp)"

    {
        echo "$user ALL=(root) NOPASSWD: /usr/bin/cp $cache/current_wallpaper.png $bg"
        echo "$user ALL=(root) NOPASSWD: /usr/bin/cp $theme $theme.bak"
        echo "$user ALL=(root) NOPASSWD: /usr/bin/sed -i * $theme"
    } > "$t"

    if run sudo visudo -cf "$t"; then
        if run sudo install -m 0440 -o root -g root "$t" "$rule"; then
            echo "  Правило установлено: $rule"
        else
            FAILED+=("sudoers: $rule")
        fi
    else
        FAILED+=("sudoers: $rule")
    fi
    rm -f "$t"
}

enable_services() {
    log "Службы и оболочка"
    for s in NetworkManager sddm; do
        run sudo systemctl enable "$s.service" || FAILED+=("служба: $s")
    done
    run sudo systemctl --global enable pipewire.socket pipewire-pulse.socket wireplumber.service || FAILED+=("службы PipeWire")
    if command -v fish >/dev/null && [[ "${SHELL:-}" != *fish ]]; then run chsh -s "$(command -v fish)" || FAILED+=("оболочка fish"); fi
}

((PKGS))  && install_native
((PKGS && AUR)) && install_aur
((PKGS))  && install_hypr_plugins
((LINKS)) && copy_configs
((SYSTEM)) && { if install_system; then install_sddm_sudoers; fi; }
((PKGS))  && enable_services

log "Готово"
if ((${#FAILED[@]})); then
    warn "Не удалось выполнить:"; printf '   - %s\n' "${FAILED[@]}"
else
    echo "Ошибок нет."
fi
cat <<'MSG'

Дальше:
  1. Положите обои в ~/Pictures/Wallpapers и запустите ~/.config/hypr/scripts/pywal.sh после выбора обоев.
  2. Перезагрузитесь и на экране входа выберите сессию Hyprland.
  3. Заменённые файлы лежат в ~/.dotfiles-backup-*
MSG
(( ${#FAILED[@]} == 0 ))
