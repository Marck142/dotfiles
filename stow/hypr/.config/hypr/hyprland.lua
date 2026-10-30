-- Точка входа Lua-конфига Hyprland.
-- Проверка: Hyprland --verify-config -c ~/.config/hypr/hyprland.lua

-- hyprpm stores plugin binaries outside the dotfiles. Load them explicitly
-- so they survive a fresh login and a Hyprland reload.
local user = assert(os.getenv("USER"), "USER is not set")
local plugin_dir = "/var/cache/hyprpm/" .. user
local state = require("lua57.configs.state")
local function load_plugin(relative_path)
    local path = plugin_dir .. "/" .. relative_path
    local file = io.open(path, "r")
    if file then
        file:close()
        hl.permission({ binary = path, type = "plugin", mode = "allow" })
        hl.plugin.load(path)
    end
end

if state.animations then
    load_plugin("hyprland-plugins/hyprfocus.so")
    load_plugin("dynamic-cursors/dynamic-cursors.so")
    load_plugin("omarchy-fx/omarchy-fx.so")
    load_plugin("HyprGlass/hyprglass.so")
end

require("lua57.configs.settings")
require("lua57.configs.decoration")
require("lua57.configs.exec")
require("lua57.configs.wrules")
require("lua57.configs.keybinds")
require("lua57.configs.environment")
require("lua57.configs.monitor")
require("lua57.configs.animation")
