local state = require("lua57.configs.state")
hl.config({ animations = { enabled = state.animations } })

hl.curve("overshot", { type = "bezier", points = { {0.13, 0.99}, {0.29, 1.15} } })
hl.curve("win", { type = "bezier", points = { {0.15, 0.90}, {0.25, 1.2} } })
hl.curve("wind", { type = "bezier", points = { {0.05, 0.9}, {0.1, 1.05} } })
hl.curve("winIn", { type = "bezier", points = { {0.1, 1.1}, {0.1, 1.1} } })
hl.curve("winOut", { type = "bezier", points = { {0.3, -0.3}, {0, 1} } })
hl.curve("liner", { type = "bezier", points = { {1, 1}, {1, 1} } })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 5, bezier = "overshot", style = "slide" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 5, bezier = "overshot", style = "slide" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 5, bezier = "wind", style = "slide" })
hl.animation({ leaf = "border", enabled = true, speed = 1, bezier = "liner" })
hl.animation({ leaf = "fade", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 5, bezier = "overshot", style = "slide" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 4, bezier = "overshot", style = "slide" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 7, bezier = "overshot", style = "slide 10%" })

local _, hyprfocus_missing = hl.get_config("plugin.hyprfocus.mouse_focus_animation")
if not hyprfocus_missing then
    hl.animation({ leaf = "hyprfocusIn", enabled = true, speed = 3, bezier = "default" })
    hl.animation({ leaf = "hyprfocusOut", enabled = true, speed = 4, bezier = "default" })
    hl.config({
        plugin = {
            hyprfocus = {
                enable = true,
                animate_floating = true,
                keyboard_focus_animation = "slide",
                mouse_focus_animation = "none",
                fade_opacity = 0.6,
                slide_height = 8,
            },
        },
    })
end

if hl.plugin and hl.plugin.dynamic_cursors then
    hl.config({
        plugin = {
            dynamic_cursors = {
                enabled = true,
                mode = "stretch",
                threshold = 4,
                stretch = { limit = 4500 },
                shake = { enabled = false, effects = false },
            },
        },
    })
end

local _, omarchy_fx_missing = hl.get_config("plugin.omarchy_fx.shake_enabled")
if not omarchy_fx_missing then
    hl.config({ plugin = { omarchy_fx = { shake_enabled = false } } })
end

if hl.plugin and hl.plugin.hyprglass then
    local glass = hl.plugin.hyprglass
    glass.config({
        default_preset = "glass",
        layers = { enabled = true },
    })
    glass.layer("waybar", { preset = "glass", mask_threshold = 0.05 })
end
