return {
    "nvim-neo-tree/neo-tree.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
    },
    cmd = "Neotree",
    keys = { "<leader>fb" },
    config = function()
        local opts = { noremap = true, silent = true }
        require("legendary").itemgroup({
            itemgroup = "neo-tree.nvim",
            keymaps = {
                {
                    "<leader>fb",
                    ":Neotree position=left toggle=true action=focus<CR>",
                    description = "Toggle the neotree sidebar",
                    opts = opts,
                },
            },
        })
        require("neo-tree").setup({
            source_selector = {
                winbar = false,
                statusline = false,
            },
            window = {
                position = "left",
                width = 30,
                mappings = {
                    ["P"] = { "toggle_preview", config = { use_float = false } },
                },
            },
            filesystem = {
                -- follow_current_file = true,
                use_libuv_file_watcher = true,
            },
        })
    end,
}
