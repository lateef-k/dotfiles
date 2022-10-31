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
		vimgrep_arguments = vimgrep_arguments,
		layout_strategy = "vertical",
        layout_config = {
            vertical = {
                height = 0.99,
                width = 0.99
            }
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
			mappings = require("mappings").telescope_lazy().buffers.mappings,
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

vim.cmd([[PackerLoad project.nvim]])
vim.cmd([[PackerLoad telescope-fzf-native.nvim]])
require("telescope").load_extension("projects")
require("telescope").load_extension("fzf")
