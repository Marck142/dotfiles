local state = require("lua57.configs.state")
local cfg = require(state.animations and "lua57.configs.configs"
    or "lua57.configs.configs_noanimation")

hl.config({
    general = {
        -- layout = master
        gaps_in = cfg.inner_gap,
        gaps_out = cfg.outer_gap,
        border_size = cfg.border,
        ["col.active_border"] = cfg.act_border,
        ["col.inactive_border"] = cfg.inact_border,
    },
    decoration = {
        rounding = cfg.rounding,
        active_opacity = cfg.opacity_act,
        inactive_opacity = cfg.opacity_deact,
        fullscreen_opacity = 1.0,
        dim_inactive = true,
        dim_strength = 0.06,
        dim_special = 0.4,
        shadow = {
            enabled = cfg.shadow_range > 0,
            range = cfg.shadow_range,
            render_power = 4,
            color = "rgba(00000055)",
            color_inactive = "rgba(00000033)",
        },
        blur = {
            enabled = cfg.blur_passes > 0,
            size = cfg.blur_size,
            passes = cfg.blur_passes,
            ignore_opacity = true,
            new_optimizations = true,
            special = true,
            popups = true,
        },
    },
})
