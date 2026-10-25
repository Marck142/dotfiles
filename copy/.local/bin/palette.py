# palette.py
import json, os, time

WAL_COLORS = os.path.expanduser("~/.cache/wal/colors.json")
_CACHE = {"mtime": 0, "colors": None}

DEFAULT = {
    "background": "#1a1a1a",
    "foreground": "#e0e0e0",
    "color0": "#282828", "color1": "#cc241d", "color2": "#98971a",
    "color3": "#d79921", "color4": "#458588", "color5": "#b16286",
    "color6": "#689d6a", "color7": "#a89984", "color8": "#928374",
    "color9": "#fb4934", "color10": "#b8bb26", "color11": "#fabd2f",
    "color12": "#83a598", "color13": "#d3869b", "color14": "#8ec07c",
    "color15": "#ebdbb2",
}

def _hex_to_rgb(h):
    h = h.lstrip("#")
    return tuple(int(h[i:i+2], 16) for i in (0, 2, 4))

def load():
    """Возвращает dict name -> (r,g,b). Поддерживает оба формата wal:
    старый плоский (color0..color15 на верхнем уровне) и новый
    (special.background/foreground + colors.color0..color15)."""
    try:
        mtime = os.path.getmtime(WAL_COLORS)
    except OSError:
        return {k: _hex_to_rgb(v) for k, v in DEFAULT.items()}
    if _CACHE["colors"] and _CACHE["mtime"] == mtime:
        return _CACHE["colors"]
    try:
        with open(WAL_COLORS) as f:
            data = json.load(f)
        flat = {}
        # новый формат: {special:{background,foreground}, colors:{color0..15}}
        if "colors" in data and isinstance(data["colors"], dict):
            flat.update(data["colors"])
        if "special" in data and isinstance(data["special"], dict):
            flat.update(data["special"])
        # старый формат: плоский
        for k, v in data.items():
            if isinstance(v, str) and v.startswith("#"):
                flat.setdefault(k, v)
        colors = {k: _hex_to_rgb(v) for k, v in flat.items() if isinstance(v, str) and v.startswith("#")}
        for k, v in DEFAULT.items():
            colors.setdefault(k, _hex_to_rgb(v))
    except Exception:
        colors = {k: _hex_to_rgb(v) for k, v in DEFAULT.items()}
    _CACHE["colors"] = colors
    _CACHE["mtime"] = mtime
    return colors

def fg(rgb):
    """ANSI truecolor foreground."""
    return f"\033[38;2;{rgb[0]};{rgb[1]};{rgb[2]}m"

def accent_pair():
    """Два акцентных цвета для градиента: обычно color5 (маджента) → color4 (синий).
    Подбери под свой wallpaper, посмотрев ~/.cache/wal/colors."""
    c = load()
    return c.get("color5", (255, 100, 180)), c.get("color4", (100, 180, 255))