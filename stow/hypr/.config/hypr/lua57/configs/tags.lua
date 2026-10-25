-- Правила перенесены в исходном порядке.

hl.window_rule({
    name = "tags-windowrule-1",
    tag = "+browser",
    match = {
        class = "^([Ff]irefox|org.mozilla.firefox|[Ff]irefox-esr|[Ff]irefox-bin)$",
    },
})

hl.window_rule({
    name = "tags-windowrule-2",
    tag = "+browser",
    match = {
        class = "^([Gg]oogle-chrome(-beta|-dev|-unstable)?)$",
    },
})

hl.window_rule({
    name = "tags-windowrule-3",
    tag = "+browser",
    match = {
        class = "^(chrome-.+-Default)$",
    },
})

hl.window_rule({
    name = "tags-windowrule-4",
    tag = "+browser",
    match = {
        class = "^([Cc]hromium)$",
    },
})

hl.window_rule({
    name = "tags-windowrule-5",
    tag = "+browser",
    match = {
        class = "^([Mm]icrosoft-edge(-stable|-beta|-dev|-unstable))$",
    },
})

hl.window_rule({
    name = "tags-windowrule-6",
    tag = "+browser",
    match = {
        class = "^([Bb]rave-browser(-beta|-dev|-unstable)?)$",
    },
})

hl.window_rule({
    name = "tags-windowrule-7",
    tag = "+browser",
    match = {
        class = "^([Tt]horium-browser|[Cc]achy-browser)$",
    },
})

hl.window_rule({
    name = "tags-windowrule-8",
    tag = "+browser",
    match = {
        class = "^(zen-alpha|zen)$",
    },
})

hl.window_rule({
    name = "tags-windowrule-9",
    tag = "+terminal",
    match = {
        class = "^(Alacritty|kitty|kitty-dropterm)$",
    },
})

hl.window_rule({
    name = "tags-windowrule-10",
    tag = "+file-manager",
    match = {
        class = "^([Tt]hunar|org.gnome.Nautilus|[Pp]cmanfm-qt)$",
    },
})

hl.window_rule({
    name = "tags-windowrule-11",
    tag = "+ide",
    match = {
        class = "^(codium|codium-url-handler|VSCodium)$",
    },
})

hl.window_rule({
    name = "tags-windowrule-12",
    tag = "+ide",
    match = {
        class = "^(VSCode|code-url-handler|code)$",
    },
})

hl.window_rule({
    name = "tags-windowrule-13",
    tag = "+ide",
    match = {
        class = "^(jetbrains-.+)$",
    },
})
