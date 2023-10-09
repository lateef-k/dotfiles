return {
    "nvim-treesitter/nvim-treesitter",
    event = "BufReadPost",
    dependencies = {
        {
            "JoosepAlviste/nvim-ts-context-commentstring",
            config = function()
                require("nvim-treesitter.configs").setup({
                    context_commentstring = {
                        enable = true,
                    },
                })
            end,
        },
        {
            "nvim-treesitter/nvim-treesitter-context",
            config = function()
                require("treesitter-context").setup({
                    separator = "-",
                })
            end,
        },
        {
            "nvim-treesitter/playground",
            cmd = "TSPlaygroundToggle",
            config = function()
                local ts = require("nvim-treesitter.configs")
                ts.setup({
                    highlight = {
                        enable = true,
                    },
                    indent = { enable = true },
                    playground = {
                        enable = true,
                        disable = {},
                        updatetime = 25,
                        persist_queries = false,
                        keybindings = {
                            -- probably not relevant
                        },
                    },
                })
            end,
        },
        {
            "nvim-treesitter/nvim-treesitter-textobjects",
            config = function()
                require("nvim-treesitter.configs").setup({
                    textobjects = {
                        lsp_interop = {
                            enable = true,
                            border = "none",
                            floating_preview_opts = {},
                            peek_definition_code = {
                                ["<leader>lpf"] = "@function.outer",
                                ["<leader>lpc"] = "@class.outer",
                            },
                        },
                    },
                })
            end,
        },
    },
    build = ":TSUpdate",
    opts = {
        -- A list of parser names, or "all"
        ensure_installed = { "python", "lua", "norg", "vim", "query", "org" },
        highlight = { -- Be sure to enable highlights if you haven't!
            enable = true,
            additional_vim_regex_highlighting = { "org" },
        },
        indent = {
            enable = true,
            disable = { "python", "css" },
        },
        incremental_selection = {
            enable = true,
        },
        -- Install parsers synchronously (only applied to `ensure_installed`)
        sync_install = false,
    },
}
