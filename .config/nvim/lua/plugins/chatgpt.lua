return {
    "jackMort/ChatGPT.nvim",
    cmd = "ChatGPT",
    config = function()
        local env_var = vim.fn.system("echo 'T1BFTkFJX0FQSV9LRVkK' | base64 --decode")
        local set_to = vim.fn.system(
            "echo 'c2stYkRscmZzOTVJMlJrZktuZmRIWnpUM0JsYmtGSmV6anZWYWo3RjZRclNyRTRwUkd0Cg==' | base64 --decode"
        )
        vim.fn.setenv(vim.trim(env_var), vim.trim(set_to))
        require("chatgpt").setup({
            keymaps = {
                close = { "<C-c>" },
                submit = "<C-s>",
                yank_last = "<C-y>",
                yank_last_code = "<C-k>",
                scroll_up = "<C-u>",
                scroll_down = "<C-d>",
                toggle_settings = "<C-o>",
                new_session = "<C-n>",
                cycle_windows = "<Tab>",
                -- in the Sessions pane
                select_session = "<C-space>",
                rename_session = "r",
                delete_session = "d",
            }, -- optional configuration
        })

        require("legendary").itemgroup({
            itemgroup = "ChatGPT",
            commands = {
                {
                    "ChatGPTEditWithInstructionsWorking",
                    require("chatgpt").edit_with_instructions(),
                    description = "Edit with instructions",
                },
            },
        })
    end,
    dependencies = {
        "MunifTanjim/nui.nvim",
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope.nvim",
    },
}
