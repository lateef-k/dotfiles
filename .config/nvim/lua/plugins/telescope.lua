local function attach_keymaps()
    local opts = { noremap = true, silent = true }
    local keymaps = {
        {
            "<leader>tt",
            ":Telescope<CR>",
            description = "Telescope",
            opts = opts,
        },
        {
            "<leader>fj",
            ":Telescope projects<CR>",
            description = "Find a project",
            opts = opts,
        },
        {
            "<leader>fp",
            require("utils.utils").find_files_in_root,
            description = "Find files in the root directory",
            opts = opts,
        },
        {
            "<leader>ff",
            ":Telescope find_files<CR>",
            description = "Find files in current directory",
            opts = opts,
        },
        {
            "<leader>fo",
            ":Telescope oldfiles<CR>",
            description = "Open recent files",
            opts = opts,
        },
        {
            "<leader>fg",
            ":Telescope git_files<CR>",
            description = "Find git files",
            opts = opts,
        },
        {
            "<leader>Z",
            function()
                local builtin = require("telescope.builtin")
                local root = require("project_nvim.project").get_project_root()
                builtin.grep_string({
                    shorten_path = true,
                    only_sort_text = true,
                    search = "",
                    cwd = root or vim.fn.expand("%:p:h"),
                })
            end,
            description = "Fuzzy search text in current project",
            opts = opts,
        },
        {
            "<leader>b",
            ":Telescope buffers<CR>",
            description = "Open a buffer",
            opts = opts,
        },
        {
            "<leader>z",
            ":Telescope current_buffer_fuzzy_find<CR>",
            description = "Fuzzy search text in the current buffer",
            opts = opts,
        },
        {
            "<leader>r",
            ":Telescope resume<CR>",
            description = "Resume the last telescope search",
            opts = opts,
        },
    }

    require("legendary").itemgroup({
        itemgroup = "telescope.nvim",
        keymaps = keymaps,
    })
end

local function config()
    attach_keymaps()
    ------------------------------ Telescope
    local telescopeConfig = require("telescope.config")
    -- Clone the default Telescope configuration
    local vimgrep_arguments = { unpack(telescopeConfig.values.vimgrep_arguments) }
    -- I want to search in hidden/dot files.
    table.insert(vimgrep_arguments, "--hidden")
    -- I don't want to search in the `.git` directory.
    table.insert(vimgrep_arguments, "--glob")
    table.insert(vimgrep_arguments, "!**/.git/*")
    require("telescope").setup({
        defaults = {
            -- this is what's fed to ripgrep
            -- `hidden = true` is not supported in text grep commands.
            mappings = {
                -- this + send to quickfix is really useful, using fzf's filtering capabilities
                n = {
                    ["<C-g>"] = require("telescope.actions").select_all,
                },
                i = {
                    ["<C-g>"] = require("telescope.actions").select_all,
                },
            },
            vimgrep_arguments = vimgrep_arguments,
            dynamic_preview_title = true,
            sorting_strategy = "ascending", -- for some reason the default "descending" setting isn't really descending..
            layout_strategy = "vertical",
            layout_config = {
                vertical = {
                    height = 0.99,
                    width = 0.99,
                },
            },
            wrap_results = true,
            -- also ignored everything listed in .rgignore .ignore .gitignore (see https://github.com/BurntSushi/ripgrep)
            file_ignore_patterns = {
                "__pycache__",
                "node_modules",
            },
            fname_width = 100,
        },
        pickers = {
            find_files = {
                find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
            },
            lsp_dynamic_workspace_symbols = {
                fname_width = 100,
            },
            buffers = {
                mappings = {
                    -- delete buffer from menu
                    n = {
                        ["<C-d>"] = require("telescope.actions").delete_buffer,
                    },
                    i = {
                        ["<C-d>"] = require("telescope.actions").delete_buffer,
                    },
                },
            },
            quickfixhistory = {
                {
                    mappings = {
                        n = {
                            ["<CR>"] = function(prompt_bufnr)
                                local selection = require("telescope.actions.state").get_selected_entry()
                                local qf_index = selection.index
                                require("telescope.actions").close(prompt_bufnr)
                                vim.cmd("silent " .. qf_index .. "chistory")
                                vim.cmd("copen")
                            end,
                        },
                        i = {
                            ["<CR>"] = function(prompt_bufnr)
                                local selection = require("telescope.actions.state").get_selected_entry()
                                local qf_index = selection.index
                                require("telescope.actions").close(prompt_bufnr)
                                vim.cmd("silent " .. qf_index .. "chistory")
                                vim.cmd("copen")
                            end,
                        },
                    },
                },
            },
        },
        extensions = {
            fzf = {
                fuzzy = true, -- false will only do exact matching
                override_generic_sorter = true, -- override the generic sorter
                override_file_sorter = true, -- override the file sorter
                case_mode = "smart_case", -- or "ignore_case" or "respect_case"
                -- the default case_mode is "smart_case"
            },
        },
    })

    require("telescope").load_extension("projects")
    require("telescope").load_extension("fzf")
end

return {
    "nvim-telescope/telescope.nvim",
    dependencies = {
        { "nvim-lua/plenary.nvim" },
        {
            "nvim-tree/nvim-web-devicons",
        },
        {
            -- i basically only use the root finder for this
            "ahmedkhalf/project.nvim",
            config = function()
                require("project_nvim").setup({
                    show_hidden = true,
                    manual_mode = true,
                })
            end,
        },
        { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    cmd = { "Telescope" },
    keys = { "<leader>f", "<leader>b", "<leader>z", "<leader>Z", "<leader>r" },
    config = config,
}
