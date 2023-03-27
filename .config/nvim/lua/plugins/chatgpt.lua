local attach_keymap = function()
    local opts = { noremap = true, silent = true }
    require("legendary").itemgroup({
        itemgroup = "ChatGPT",
        description = "ChatGPT",
        commands = {
            {
                "ChatGPT",
                function()
                    require("chatgpt").openChat()
                end,
                description = "Opens a chat window powered by GPT-3",
            },
            {
                "ChatGPTActAs",
                function()
                    require("chatgpt").selectAwesomePrompt()
                end,
                description = "Selects an awesome prompt for the chat window",
            },
            {
                "ChatGPTEditSelection",
                function()
                    require("chatgpt").edit_with_instructions()
                end,
                description = "Opens a new buffer with instructions for using the chat window",
                opts = {
                    range = true,
                },
            },
            {
                "ChatGPTRun",
                function(gpt_opts)
                    require("chatgpt").run_action(gpt_opts)
                end,
                opts = {
                    range = true,
                },
                description = "Runs an action defined in the chatgpt.flows.actions module",
            },
            {
                "ChatGPTRunCustomCodeAction",
                function(gpt_opts)
                    require("chatgpt").run_custom_code_action(gpt_opts)
                end,
                description = "Runs a custom code action defined in the chatgpt.flows.actions module",
            },
            {
                "ChatGPTCompleteCode",
                function()
                    require("chatgpt").complete_code()
                end,
                description = "Completes code using G",
            },
        },
        keymaps = {
            { "<leader>x", ":ChatGPT<CR>", opts = opts, description = "Open ChatGPT Window" },
        },
    })
end

return {
    "jackMort/ChatGPT.nvim",
    cmd = "ChatGPT",
    keys = { "<leader>x" },
    config = function()
        attach_keymap()
        local env_var = vim.fn.system("echo 'T1BFTkFJX0FQSV9LRVkK' | base64 --decode")
        local set_to = vim.fn.system(
            "echo 'c2stYkRscmZzOTVJMlJrZktuZmRIWnpUM0JsYmtGSmV6anZWYWo3RjZRclNyRTRwUkd0Cg==' | base64 --decode"
        )
        vim.fn.setenv(vim.trim(env_var), vim.trim(set_to))
        require("chatgpt").setup({
            openai_params = {
                model = "gpt-3.5-turbo",
                frequency_penalty = 0,
                presence_penalty = 0,
                max_tokens = 1000,
                temperature = 0,
                top_p = 1,
                n = 1,
            },
            openai_edit_params = {
                temperature = 0,
                top_p = 1,
                n = 1,
            },
            keymaps = {
                close = { "<C-c>" },
                submit = "<C-s>",
                yank_last = "<C-y>",
                yank_last_code = "<C-k>",
                scroll_up = "<C-u>",
                scroll_down = "<C-d>",
                new_session = "<C-n>",

                --- THE COMMANDS BELOW ONLY WORK WHEN SETTINGS IS OPEN
                toggle_settings = "<C-o>",
                cycle_windows = "<Tab>",
                -- in the Sessions pane
                rename_session = "r",
                delete_session = "d",
            }, -- optional configuration
        })
    end,
    dependencies = {
        "MunifTanjim/nui.nvim",
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope.nvim",
    },
}
