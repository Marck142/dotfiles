hl.config({
    input = {
        kb_layout = "us, ru",
        kb_variant = "",
        kb_model = "",
        kb_options = "grp:win_space_toggle",
        kb_rules = "",
        repeat_rate = 50,
        repeat_delay = 300,
        numlock_by_default = true,
        left_handed = false,
        follow_mouse = true,
        float_switch_override_focus = false,
        touchpad = {
            disable_while_typing = true,
            natural_scroll = true,
            clickfinger_behavior = false,
            middle_button_emulation = true,
            tap_to_click = true,
            drag_lock = false,
        },
        sensitivity = 0,
    },
    misc = {
        disable_hyprland_logo = true,
        disable_splash_rendering = true,
        vrr = 2,
        mouse_move_enables_dpms = true,
        enable_swallow = true,
        swallow_regex = "^(kitty)$",
        focus_on_activate = false,
        initial_workspace_tracking = 0,
        middle_click_paste = false,
    },
    dwindle = {
        preserve_split = true,
    },
    master = {
        new_status = "master",
    },
    binds = {
        workspace_back_and_forth = true,
        allow_workspace_cycles = true,
        pass_mouse_when_bound = false,
    },
    xwayland = {
        enabled = true,
        force_zero_scaling = true,
    },
    render = {
        direct_scanout = false,
    },
    cursor = {
        sync_gsettings_theme = true,
        no_hardware_cursors = 2,
        enable_hyprcursor = true,
        warp_on_change_workspace = 2,
        no_warps = true,
    },
    -- Жесты переключения воркспейсов (вместо gestures{})
})

-- Исходные switch-бинды сохранены, это НЕ touchpad-жесты.
hl.bind("switch:3:workspace", hl.dsp.focus({ workspace = "e+1" }), { repeating = true })
hl.bind("switch:4:workspace", hl.dsp.focus({ workspace = "e-1" }), { repeating = true })
hl.bind("switch:3:workspace", hl.dsp.focus({ workspace = "r+1" }), { repeating = true })
hl.bind("switch:4:workspace", hl.dsp.focus({ workspace = "r-1" }), { repeating = true })
