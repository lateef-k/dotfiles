local function attach_keymap()
    local opts = { noremap = true, silent = true }
    local keymaps = {
        {
            "q",
            "<Plug>(leap-forward-to)",
            description = "Leap forward to a character",
            mode = { "n", "x", "o" },
            opts = opts,
        },

        {
            "Q",
            "<Plug>(leap-backward-to)",
            description = "Leap backward to a character",
            mode = { "n", "x", "o" },
            opts = opts,
        },

        {
            "x",
            "<Plug>(leap-forward-till)",
            description = "Leap forward to before a character",
            mode = { "x", "o" },
            opts = opts,
        },

        {
            "X",
            "<Plug>(leap-backward-till)",
            description = "Leap backward to after a character",
            mode = { "x", "o" },
            opts = opts,
        },

        {
            "<C-q>",
            "<Plug>(leap-cross-window)",
            description = "Leap to a character in another window",
            mode = { "n", "x", "o" },
            opts = opts,
        },
    }
    require("legendary").itemgroup({
        itemgroup = "leap.nvim",
        keymaps = keymaps,
    })
end

return {
    "ggandor/leap.nvim",
    keys = {
        "<Plug>(leap-forward-to)",
        "<Plug>(leap-backward-to)",
        "<Plug>(leap-forward-till)",
        "<Plug>(leap-backward-till)",
        "<Plug>(leap-cross-window)",
    },
    config = attach_keymap,
}
