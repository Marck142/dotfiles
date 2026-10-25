-- Отдельная точка входа. hyprland.conf и luaconfigs не используются и не изменяются.
-- Проверка: Hyprland --verify-config -c ~/.config/hypr/hyprland-0.57.lua
-- Загрузка через -c оставляет выбор старого конфига по умолчанию без изменений.
require("lua57.configs.settings")
require("lua57.configs.decoration")
require("lua57.configs.exec")
require("lua57.configs.wrules")
require("lua57.configs.keybinds")
require("lua57.configs.environment")
require("lua57.configs.monitor")
require("lua57.configs.animation")
