local function attach_keymap()
    local opts = { noremap = true, silent = true }
    local keymaps = {
        {
            "<localleader>lv",
            ":LegendaryEvalLines<CR>",
            opts = opts,
            mode = { "x" },
            description = "Evaluate lines",
        },
        { "<localleader>le", ":LegendaryEvalLine<CR>",      opts = opts,          description = "Evaluate currnetline" },
        { "<localleader>ls", ":LegendaryScratchToggle<CR>", opts = opts,          description = "Toggle scratch buffer" },
        { "<C-p>",           ":Legendary<CR>",              modes = { "n", "i" }, opts = opts,                          description = "Toggle scratch buffer" },
    }

    require("legendary").itemgroup({
        itemgroup = "legendary.nvim",
        keymaps = keymaps,
    })
end

return {
    "mrjones2014/legendary.nvim",
    -- sqlite is only needed if you want to use frecency sorting
    dependencies = "kkharji/sqlite.lua",
    config = attach_keymap,
}
