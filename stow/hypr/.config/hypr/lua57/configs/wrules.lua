-- Правила перенесены в исходном порядке.
local cfg = require("lua57.configs.configs")
require("lua57.configs.tags")

hl.window_rule({
    name = "wrules-windowrule-1",
    float = true,
    match = {
        class = "^(org.kde.polkit-kde-authentication-agent-1)$",
    },
})

hl.window_rule({
    name = "wrules-windowrule-2",
    float = true,
    match = {
        tag = "file-manager*",
        title = "(File Operation Progress)",
    },
})

hl.window_rule({
    name = "wrules-windowrule-3",
    float = true,
    center = true,
    match = {
        class = "([Tt]hunar)",
        title = "(Confirm to replace files)",
    },
})

hl.window_rule({
    name = "wrules-windowrule-4",
    float = true,
    size = "(monitor_w*0.6) (monitor_h*0.7)",
    match = {
        class = "^(pavucontrol|org.pulseaudio.pavucontrol)$",
    },
})

hl.window_rule({
    name = "wrules-windowrule-5",
    float = true,
    size = "(monitor_w*0.6) (monitor_h*0.7)",
    match = {
        class = "^(nwg-look|qt5ct|qt6ct|mpv)$",
    },
})

hl.window_rule({
    name = "wrules-windowrule-6",
    float = true,
    size = "(monitor_w*0.6) (monitor_h*0.7)",
    match = {
        class = "^(kitty)$",
        title = "(update)",
    },
})

hl.window_rule({
    name = "wrules-windowrule-7",
    float = true,
    size = "(monitor_w*0.6) (monitor_h*0.6)",
    match = {
        class = "^(kitty)$",
        title = "(yazi)",
    },
})

hl.window_rule({
    name = "wrules-windowrule-8",
    float = true,
    size = "(monitor_w*0.5) (monitor_h*0.55)",
    match = {
        class = "^(kitty)$",
        title = "(monitor)",
    },
})

hl.window_rule({
    name = "wrules-windowrule-9",
    float = true,
    size = "(monitor_w*0.5) (monitor_h*0.6)",
    match = {
        class = "^(kitty)$",
        title = "(browser)",
    },
})

hl.window_rule({
    name = "wrules-windowrule-10",
    float = true,
    size = "(monitor_w*0.7) (monitor_h*0.8)",
    match = {
        class = "^(kitty)$",
        title = "(floating)",
    },
})

hl.window_rule({
    name = "wrules-windowrule-11",
    float = true,
    match = {
        class = "^(file-roller|org.gnome.FileRoller)$",
    },
})

hl.window_rule({
    name = "wrules-windowrule-12",
    float = true,
    size = "(monitor_w*0.6) (monitor_h*0.8)",
    match = {
        class = "^([Kk]vantummanager)$",
    },
})

hl.window_rule({
    name = "wrules-windowrule-13",
    float = true,
    size = "(monitor_w*0.6) (monitor_h*0.8)",
    match = {
        class = "^([Ll]xappearance)$",
    },
})

hl.window_rule({
    name = "wrules-windowrule-14",
    float = true,
    center = true,
    match = {
        class = "^(yad)$",
    },
})

hl.window_rule({
    name = "wrules-windowrule-15",
    float = true,
    size = "(monitor_w*0.6) (monitor_h*0.8)",
    match = {
        class = "^(eog)$",
    },
})

hl.window_rule({
    name = "wrules-windowrule-16",
    float = true,
    size = "(monitor_w*0.6) (monitor_h*0.8)",
    match = {
        class = "^([Tt]hunar)$",
    },
})

hl.window_rule({
    name = "wrules-windowrule-17",
    float = true,
    match = {
        class = "^([Gg]nome-disks)$",
    },
})

hl.window_rule({
    name = "wrules-windowrule-18",
    float = true,
    size = "(monitor_w*0.5) (monitor_h*0.8)",
    match = {
        class = "^(com.obsproject.Studio)$",
    },
})

hl.window_rule({
    name = "wrules-windowrule-19",
    float = true,
    size = "(monitor_w*0.6) (monitor_h*0.8)",
    match = {
        class = "^(org.telegram.desktop)$",
    },
})

hl.window_rule({
    name = "wrules-windowrule-20",
    float = true,
    center = true,
    match = {
        title = "^(Authentication Required)$",
    },
})

hl.window_rule({
    name = "wrules-windowrule-21",
    float = true,
    match = {
        class = "(codium|codium-url-handler|VSCodium)",
        title = "negative:(.*codium.*|.*VSCodium.*)",
    },
})

hl.window_rule({
    name = "wrules-windowrule-22",
    float = true,
    match = {
        class = "^(com.heroicgameslauncher.hgl)$",
        title = "negative:(Heroic Games Launcher)",
    },
})

hl.window_rule({
    name = "wrules-windowrule-23",
    float = true,
    match = {
        class = "^([Ss]team)$",
        title = "negative:^([Ss]team)$",
    },
})

hl.window_rule({
    name = "wrules-windowrule-24",
    float = true,
    match = {
        class = "([Tt]hunar)",
        title = "negative:(.*[Tt]hunar.*)",
    },
})

hl.window_rule({
    name = "wrules-windowrule-25",
    float = true,
    match = {
        class = "(xdg-desktop-portal-gtk)",
    },
})

hl.window_rule({
    name = "wrules-windowrule-26",
    float = true,
    match = {
        class = "(electron)",
        title = "(Add Folder to Workspace)",
    },
})

hl.window_rule({
    name = "wrules-windowrule-27",
    float = true,
    match = {
        title = "^(Add Folder to Workspace)$",
    },
})

hl.window_rule({
    name = "wrules-windowrule-28",
    float = true,
    match = {
        tag = "browser*",
        initial_title = "^(wants to open)$",
    },
})

hl.window_rule({
    name = "wrules-windowrule-29",
    float = true,
    match = {
        initial_title = "(Open Files)",
    },
})

hl.window_rule({
    name = "wrules-windowrule-30",
    size = "(monitor_w*0.6) (monitor_h*0.8)",
    center = true,
    match = {
        class = "^(nwg-look)$",
    },
})

hl.window_rule({
    name = "wrules-windowrule-31",
    size = "(monitor_w*0.2) (monitor_h*0.4)",
    match = {
        class = "^([Tt]hunar)$",
        title = "(File Operation Progress)",
    },
})

hl.window_rule({
    name = "wrules-windowrule-32",
    size = "(monitor_w*0.2) (monitor_h*0.4)",
    match = {
        class = "^([Tt]hunar)$",
        title = "(Confirm to replace files)",
    },
})

hl.window_rule({
    name = "wrules-windowrule-33",
    size = "(monitor_w*0.7) (monitor_h*0.7)",
    match = {
        class = "^(xdg-desktop-portal-gtk)$",
    },
})

hl.window_rule({
    name = "wrules-windowrule-34",
    size = "(monitor_w*0.6) (monitor_h*0.7)",
    match = {
        title = "(Kvantum Manager)",
    },
})

hl.window_rule({
    name = "wrules-windowrule-35",
    center = true,
    match = {
        class = "([Tt]hunar)",
        title = "(File Operation Progress)",
    },
})

hl.window_rule({
    name = "wrules-windowrule-36",
    center = true,
    match = {
        class = "^(qt5ct)$",
    },
})

hl.window_rule({
    name = "wrules-windowrule-37",
    center = true,
    match = {
        class = "^(lxappearance)$",
    },
})

hl.window_rule({
    name = "wrules-windowrule-38",
    center = true,
    match = {
        class = "^(kitty)$",
        title = "(yazi|update|browser)",
    },
})

hl.window_rule({
    name = "wrules-windowrule-39",
    opacity = tostring(cfg.opacity_act) .. " " .. tostring(cfg.opacity_deact),
    match = {
        tag = "ide*",
    },
})

hl.window_rule({
    name = "wrules-windowrule-40",
    opacity = tostring(cfg.opacity_act) .. " " .. tostring(cfg.opacity_deact),
    match = {
        tag = "terminal*",
    },
})

hl.window_rule({
    name = "wrules-windowrule-41",
    opacity = tostring(cfg.opacity_act) .. " " .. tostring(cfg.opacity_deact),
    match = {
        tag = "file-manager*",
    },
})

hl.window_rule({
    name = "wrules-windowrule-42",
    opacity = "1.0" .. " " .. tostring(cfg.opacity_deact),
    match = {
        tag = "browser*",
    },
})

hl.workspace_rule({ workspace = "special:exposed", gaps_out = 60, gaps_in = 30, border_size = 5, no_border = false, no_shadow = true })

hl.layer_rule({
    name = "wrules-layerrule-1",
    blur = true,
    ignore_alpha = 0,
    match = {
        namespace = "notifications",
    },
})

hl.layer_rule({
    name = "wrules-layerrule-2",
    blur = true,
    ignore_alpha = 0,
    match = {
        namespace = "rofi",
    },
})

hl.layer_rule({
    name = "wrules-layerrule-3",
    blur = true,
    match = {
        namespace = "logout_dialog",
    },
})

hl.layer_rule({
    name = "wrules-layerrule-4",
    blur = true,
    ignore_alpha = 0,
    match = {
        namespace = "swaync-control-center",
    },
})

hl.layer_rule({
    name = "wrules-layerrule-5",
    blur = true,
    ignore_alpha = 0,
    match = {
        namespace = "swaync-notification-window",
    },
})

hl.workspace_rule({ workspace = "1", monitor = "HDMI-A-1" })

hl.workspace_rule({ workspace = "2", monitor = "HDMI-A-1" })

hl.workspace_rule({ workspace = "3", monitor = "HDMI-A-1" })

hl.workspace_rule({ workspace = "4", monitor = "HDMI-A-1" })

hl.workspace_rule({ workspace = "5", monitor = "HDMI-A-1" })

hl.workspace_rule({ workspace = "6", monitor = "HDMI-A-2" })

hl.workspace_rule({ workspace = "7", monitor = "HDMI-A-2" })

hl.workspace_rule({ workspace = "8", monitor = "HDMI-A-2" })
