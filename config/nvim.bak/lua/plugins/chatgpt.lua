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
            yank_register = "+",
            edit_with_instructions = {
                diff = false,
                keymaps = {
                    accept = "<C-s>",
                    toggle_diff = "<C-d>",
                    toggle_settings = "<C-o>",
                    cycle_windows = "<Tab>",
                    use_output_as_input = "<C-i>",
                },
            },
            chat = {
                welcome_message = WELCOME_MESSAGE,
                loading_text = "Loading, please wait ...",
                question_sign = "", -- 🙂
                answer_sign = "ﮧ", -- 🤖
                max_line_length = 120,
                sessions_window = {
                    border = {
                        style = "rounded",
                        text = {
                            top = " Sessions ",
                        },
                    },
                    win_options = {
                        winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
                    },
                },
                keymaps = {
                    close = { "<C-c>" },
                    yank_last = "<C-y>",
                    yank_last_code = "<C-k>",
                    scroll_up = "<C-u>",
                    scroll_down = "<C-d>",
                    toggle_settings = "<C-o>",
                    new_session = "<C-n>",
                    cycle_windows = "<Tab>",
                    select_session = "<Space>",
                    rename_session = "r",
                    delete_session = "d",
                },
            },
            popup_layout = {
                relative = "editor",
                position = "50%",
                size = {
                    height = "80%",
                    width = "80%",
                },
            },
            popup_window = {
                filetype = "chatgpt",
                border = {
                    highlight = "FloatBorder",
                    style = "rounded",
                    text = {
                        top = " ChatGPT ",
                    },
                },
                win_options = {
                    winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
                },
            },
            popup_input = {
                prompt = "  ",
                border = {
                    highlight = "FloatBorder",
                    style = "rounded",
                    text = {
                        top_align = "center",
                        top = " Prompt ",
                    },
                },
                win_options = {
                    winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
                },
                submit = "<M-CR>",
            },
            settings_window = {
                border = {
                    style = "rounded",
                    text = {
                        top = " Settings ",
                    },
                },
                win_options = {
                    winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
                },
            },
            openai_params = {
                model = "gpt-3.5-turbo",
                frequency_penalty = 0,
                presence_penalty = 0,
                max_tokens = 300,
                temperature = 0,
                top_p = 1,
                n = 1,
            },
            openai_edit_params = {
                model = "code-davinci-edit-001",
                temperature = 0,
                top_p = 1,
                n = 1,
            },
            actions_paths = {},
            predefined_chat_gpt_prompts = "https://raw.githubusercontent.com/f/awesome-chatgpt-prompts/main/prompts.csv",
        })
    end,
    dependencies = {
        "MunifTanjim/nui.nvim",
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope.nvim",
    },
}
