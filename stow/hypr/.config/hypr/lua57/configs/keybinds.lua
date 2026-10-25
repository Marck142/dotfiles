-- Все активные бинды из configs/keybinds.conf в исходном порядке.
-- $ALT / $CONTROL были не объявлены: здесь используются ALT / CTRL.
local home = assert(os.getenv("HOME"), "HOME is not set")
local scriptsDir = home .. "/.config/hypr/scripts"
local luaScriptsDir = home .. "/.config/hypr/lua57/scripts"

local toggle_all_floating = require("lua57.configs.actions").toggle_all_floating


-- Custom Variables

-- Change Wallpaper
hl.bind("SUPER + W", hl.dsp.exec_cmd("skwd wall list | jq -c '.wallpapers[] | {path: (if .type == \"video\" then .video_file else .name end), type: .type}' | shuf -n 1 | xargs -0 -I {} skwd wall apply '{}'"))
hl.bind("SUPER + SHIFT + W", hl.dsp.exec_cmd("skwd wall toggle"))

-- Screenshot
hl.bind("F12", hl.dsp.exec_cmd("~/.config/hypr/scripts/screenshot.sh"))

-- Key Binds Help
hl.bind("SUPER + SHIFT + h", hl.dsp.exec_cmd(scriptsDir .. "/keybinds.sh"))

hl.bind("SUPER + Return", hl.dsp.exec_cmd("kitty --title main"))
hl.bind("SUPER + SHIFT + Return", hl.dsp.exec_cmd("kitty --title floating"))
hl.bind("SUPER + Q", hl.dsp.window.close())
hl.bind("SUPER + SHIFT + M", hl.dsp.exit())
hl.bind("SUPER + E", hl.dsp.exec_cmd("thunar"))
hl.bind("SUPER + SHIFT + E", hl.dsp.exec_cmd("kitty --title yazi -e yazi"))
hl.bind("SUPER + V", hl.dsp.window.float())
hl.bind("SUPER + ALT + v", toggle_all_floating)
hl.bind("SUPER + f", hl.dsp.window.fullscreen())
hl.bind("SUPER + D", hl.dsp.exec_cmd(scriptsDir .. "/menu.sh || pkill rofi"))
hl.bind("SUPER + ALT + D", hl.dsp.exec_cmd(scriptsDir .. "/rofi_theme.sh"))
hl.bind("SUPER + ALT + c", hl.dsp.exec_cmd(scriptsDir .. "/cliphist.sh c"))
hl.bind("SUPER + ALT + w", hl.dsp.exec_cmd(scriptsDir .. "/cliphist.sh w"))
hl.bind("SUPER + SHIFT + D", hl.dsp.exec_cmd(scriptsDir .. "/rofi-emoji.sh"))
hl.bind("SUPER + SHIFT + P", hl.dsp.window.pseudo())
hl.bind("SUPER + x", hl.dsp.exec_cmd(luaScriptsDir .. "/powermenu.sh"))
hl.bind("SUPER + ALT + x", hl.dsp.exec_cmd(luaScriptsDir .. "/powermenu_theme_select.sh"))
hl.bind("SUPER + c", hl.dsp.exec_cmd("code"))
hl.bind("SUPER + b", hl.dsp.exec_cmd(scriptsDir .. "/browser.sh op"))
hl.bind("ALT + b", hl.dsp.exec_cmd(scriptsDir .. "/default_browser.sh --reset"))
hl.bind("CTRL + ESCAPE", hl.dsp.exec_cmd(scriptsDir .. "/waybar-reload.sh --reload"))
hl.bind("CTRL + ALT + ESCAPE", hl.dsp.exec_cmd(scriptsDir .. "/waybar-reload.sh --toggle"))
hl.bind("SUPER + SHIFT + l", hl.dsp.exec_cmd("hyprlock"))
hl.bind("SUPER + ALT + l", hl.dsp.exec_cmd(scriptsDir .. "/hyprlock.sh"))
-- bind = $mainMod ALT, l, exec, $scriptsDir/dark_light.sh
hl.bind("SUPER + CTRL + w", hl.dsp.exec_cmd(luaScriptsDir .. "/waybar-layout.sh"))
hl.bind("SUPER + CTRL + e", hl.dsp.exec_cmd(scriptsDir .. "/edit-dotfiles.sh"))
hl.bind("SUPER + ALT + b", hl.dsp.exec_cmd(scriptsDir .. "/shell.sh"))
hl.bind("SUPER + CTRL + R", hl.dsp.exec_cmd("hyprctl reload && notify-send \"Done\" \"Hyprland reload\""))
hl.bind("CTRL + u", hl.dsp.exec_cmd(scriptsDir .. "/systemupdate.sh --update"))
hl.bind("SUPER + CTRL + U", hl.dsp.exec_cmd("kitty --title browser sh -c \"" .. scriptsDir .. "/hyprconf.sh\""))
hl.bind("SUPER + SHIFT + R", hl.dsp.exec_cmd(scriptsDir .. "/startup.sh &> /dev/null"))
hl.bind("SUPER + s", hl.dsp.exec_cmd("kitty --title settings --hold sh -c \"" .. luaScriptsDir .. "/settings.sh\""))
hl.bind("SUPER + T", hl.dsp.exec_cmd(scriptsDir .. "/dark_light.sh"))
hl.bind("SUPER + ALT + U", hl.dsp.exec_cmd("kitty sh -c \"" .. scriptsDir .. "/uninstall.sh\""))
hl.bind("SUPER + F1", hl.dsp.exec_cmd(luaScriptsDir .. "/animations_toggle.sh"))

-- re-generate colors if the ~/.cache/wal directory has been deleted
hl.bind("SUPER + CTRL + p", hl.dsp.exec_cmd("notify-send \"Colors\" \"Re-generating colors.\" && " .. scriptsDir .. "/pywal.sh"))

-- switch window
hl.bind("SUPER + Tab", hl.dsp.exec_cmd("rofi -show window -theme ~/.config/rofi/themes/rofi-window.rasi"))
-- Cycle windows if floating bring to top
hl.bind("ALT + tab", hl.dsp.window.cycle_next())
hl.bind("ALT + tab", hl.dsp.window.bring_to_top())
hl.bind("SUPER + G", hl.dsp.group.toggle())
hl.bind("SUPER + M", hl.dsp.layout("splitratio 0.3"))
hl.bind("SUPER + SHIFT + I", hl.dsp.layout("togglesplit"))
hl.bind("SUPER + P", hl.dsp.window.pseudo())


-- Audio control
hl.bind("F9", hl.dsp.exec_cmd(scriptsDir .. "/volumecontrol.sh --toggle"))
hl.bind("F10", hl.dsp.exec_cmd(scriptsDir .. "/volumecontrol.sh --dec"))
hl.bind("F11", hl.dsp.exec_cmd(scriptsDir .. "/volumecontrol.sh --inc"))
-- Audio Control for Laptop Keys
hl.bind("XF86AudioMute", hl.dsp.exec_cmd(scriptsDir .. "/volumecontrol.sh --toggle"))
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(scriptsDir .. "/volumecontrol.sh --dec"))
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(scriptsDir .. "/volumecontrol.sh --inc"))


-- hyprsunset
-- bind = $mainMod, F1, exec, $scriptsDir/nightlight.sh --dec  # night light
-- bind = $mainMod, F2, exec, $scriptsDir/nightlight.sh --inc # day light
-- bind = $mainMod, F3, exec, $scriptsDir/nightlight.sh --def # default value

-- brightness
-- bind = , F3, exec, ~/.config/hypr/scripts/brightness.sh up
-- bind = , F2, exec, ~/.config/hypr/scripts/brightness.sh down
-- brightness control for Laptop Keys
-- bind = , XF86MonBrightnessUP, exec, ~/.config/hypr/scripts/brightness.sh up
-- bind = , XF86MonBrightnessDOWN, exec, ~/.config/hypr/scripts/brightness.sh down


-- Move focus with mainMod + arrow keys
hl.bind("SUPER + j", hl.dsp.focus({ direction = "down" }))
hl.bind("SUPER + k", hl.dsp.focus({ direction = "up" }))
hl.bind("SUPER + l", hl.dsp.focus({ direction = "right" }))
hl.bind("SUPER + h", hl.dsp.focus({ direction = "left" }))

-- Move active window around current workspace with mainMod + SHIFT + CTRL [←→↑↓]
hl.bind("SUPER + CTRL + j", hl.dsp.window.move({ direction = "down" }))
hl.bind("SUPER + CTRL + k", hl.dsp.window.move({ direction = "up" }))
hl.bind("SUPER + CTRL + l", hl.dsp.window.move({ direction = "right" }))
hl.bind("SUPER + CTRL + h", hl.dsp.window.move({ direction = "left" }))

-- Resize windows
hl.bind("SUPER + left", hl.dsp.window.resize({ x = -50, y = 0, relative = true }), { repeating = true })
hl.bind("SUPER + right", hl.dsp.window.resize({ x = 50, y = 0, relative = true }), { repeating = true })
hl.bind("SUPER + up", hl.dsp.window.resize({ x = 0, y = -50, relative = true }), { repeating = true })
hl.bind("SUPER + down", hl.dsp.window.resize({ x = 0, y = 50, relative = true }), { repeating = true })

-- Switch workspaces with mainMod + [0-9]
hl.bind("SUPER + 1", hl.dsp.focus({ workspace = 1 }))
hl.bind("SUPER + 2", hl.dsp.focus({ workspace = 2 }))
hl.bind("SUPER + 3", hl.dsp.focus({ workspace = 3 }))
hl.bind("SUPER + 4", hl.dsp.focus({ workspace = 4 }))
hl.bind("SUPER + 5", hl.dsp.focus({ workspace = 5 }))
hl.bind("SUPER + 6", hl.dsp.focus({ workspace = 6 }))
hl.bind("SUPER + 7", hl.dsp.focus({ workspace = 7 }))
hl.bind("SUPER + 8", hl.dsp.focus({ workspace = 8 }))
hl.bind("SUPER + 9", hl.dsp.focus({ workspace = 9 }))
hl.bind("SUPER + 0", hl.dsp.focus({ workspace = 10 }))

-- Move active window to a workspace with mainMod + SHIFT + [0-9]
hl.bind("SUPER + SHIFT + 1", hl.dsp.window.move({ workspace = 1, follow = true }))
hl.bind("SUPER + SHIFT + 2", hl.dsp.window.move({ workspace = 2, follow = true }))
hl.bind("SUPER + SHIFT + 3", hl.dsp.window.move({ workspace = 3, follow = true }))
hl.bind("SUPER + SHIFT + 4", hl.dsp.window.move({ workspace = 4, follow = true }))
hl.bind("SUPER + SHIFT + 5", hl.dsp.window.move({ workspace = 5, follow = true }))
hl.bind("SUPER + SHIFT + 6", hl.dsp.window.move({ workspace = 6, follow = true }))
hl.bind("SUPER + SHIFT + 7", hl.dsp.window.move({ workspace = 7, follow = true }))
hl.bind("SUPER + SHIFT + 8", hl.dsp.window.move({ workspace = 8, follow = true }))
hl.bind("SUPER + SHIFT + 9", hl.dsp.window.move({ workspace = 9, follow = true }))
hl.bind("SUPER + SHIFT + 0", hl.dsp.window.move({ workspace = 10, follow = true }))

-- Move window silently to workspace Super + Alt + [0-9]
hl.bind("SUPER + ALT + 1", hl.dsp.window.move({ workspace = 1, follow = false }))
hl.bind("SUPER + ALT + 2", hl.dsp.window.move({ workspace = 2, follow = false }))
hl.bind("SUPER + ALT + 3", hl.dsp.window.move({ workspace = 3, follow = false }))
hl.bind("SUPER + ALT + 4", hl.dsp.window.move({ workspace = 4, follow = false }))
hl.bind("SUPER + ALT + 5", hl.dsp.window.move({ workspace = 5, follow = false }))
hl.bind("SUPER + ALT + 6", hl.dsp.window.move({ workspace = 6, follow = false }))
hl.bind("SUPER + ALT + 7", hl.dsp.window.move({ workspace = 7, follow = false }))
hl.bind("SUPER + ALT + 8", hl.dsp.window.move({ workspace = 8, follow = false }))
hl.bind("SUPER + ALT + 9", hl.dsp.window.move({ workspace = 9, follow = false }))
hl.bind("SUPER + ALT + 0", hl.dsp.window.move({ workspace = 10, follow = false }))

-- Scroll through existing workspaces with mainMod + scroll
hl.bind("SUPER + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind("SUPER + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true })


-- pyprland related
hl.bind("SUPER + A", hl.dsp.exec_cmd("pypr toggle term"))
hl.bind("SUPER + N", hl.dsp.exec_cmd("pypr toggle_special minimized"))
hl.bind("SUPER + SHIFT + N", hl.dsp.workspace.toggle_special("minimized"))
hl.bind("SUPER + SHIFT + Z", hl.dsp.exec_cmd("pypr zoom ++0.5"))
hl.bind("SUPER + Z", hl.dsp.exec_cmd("pypr zoom"))

-- Управление музыкой
hl.bind("F6", hl.dsp.exec_cmd("playerctl previous"))
hl.bind("F7", hl.dsp.exec_cmd("playerctl play-pause"))
hl.bind("F8", hl.dsp.exec_cmd("playerctl next"))

-- Управление ВПН WireGuard
hl.bind("SUPER + CTRL + v", hl.dsp.exec_cmd("~/.config/hypr/scripts/vpn-toggle.sh"))

-- Бинды на сайты
hl.bind("CTRL + SUPER + D", hl.dsp.exec_cmd("~/.config/hypr/scripts/apps.sh ds"))
hl.bind("CTRL + SUPER + G", hl.dsp.exec_cmd("~/.config/hypr/scripts/apps.sh gem"))
hl.bind("CTRL + P", hl.dsp.exec_cmd("~/.config/hypr/scripts/apps.sh porno"))
hl.bind("SHIFT + SUPER + G", hl.dsp.exec_cmd("~/.config/hypr/scripts/apps.sh github"))

-- Включение/выключение автокликера для диалогов Геншина
hl.bind("ALT + M", hl.dsp.exec_cmd("~/.config/hypr/scripts/genshin_skip.sh"))
