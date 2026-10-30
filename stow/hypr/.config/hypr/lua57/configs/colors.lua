-- Pywal: читаем JSON как данные, не выполняем ни Lua, ни Hyprlang из кэша.
-- На каждом reload require загружает свежую палитру.
local colors = {
    active = "rgba(4A7EC1FF)",
    inactive = "rgba(a4c3e0FF)",
}
local home = assert(os.getenv("HOME"), "HOME is not set")
local file = io.open(home .. "/.cache/wal/colors.json", "r")
if file then
    local data = file:read("*a")
    file:close()
    local function rgba(name)
        local value = data:match('"' .. name .. '"%s*:%s*"#(%x+)"')
        if value and #value == 6 then
            return "rgba(" .. value .. "FF)"
        end
    end
    colors.active = rgba("color5") or colors.active
    colors.inactive = rgba("foreground") or colors.inactive
end
return colors
