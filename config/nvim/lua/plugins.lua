-- Plugin specs
--
local command = vim.api.nvim_create_user_command

local plugins = {
	{
		"mbbill/undotree",
	},
	{
		"aserowy/tmux.nvim",
		config = true,
		event = "VeryLazy",
		keys = {
			{ "<C-h>", "<cmd>lua require'tmux'.move_left()<cr>", mode = { "n", "i", "t" } },
			{ "<C-j>", "<cmd>lua require'tmux'.move_bottom()<cr>", mode = { "n", "i", "t" } },
			{ "<C-k>", "<cmd>lua require'tmux'.move_top()<cr>", mode = { "n", "i", "t" } },
			{ "<C-l>", "<cmd>lua require'tmux'.move_right()<cr>", mode = { "n", "i", "t" } },
		},
		opts = {
			navigation = {
				enable_default_keybindings = true,
			},
		},
	},
	{
		"folke/lazydev.nvim",
		ft = "lua", -- only load on lua files
		opts = {
			library = {
				-- See the configuration section for more details
				-- Load luvit types when the `vim.uv` word is found
				{ path = "luvit-meta/library", words = { "vim%.uv" } },
			},
		},
	},
	{ "Bilal2453/luvit-meta", lazy = true }, -- optional `vim.uv` typings
	{
		"saghen/blink.cmp",
		lazy = true, -- lazy loading handled internally
		-- optional: provides snippets for the snippet source
		dependencies = "rafamadriz/friendly-snippets",

		version = "*",
		event = { "InsertEnter", "CmdlineEnter" },

		-- use a release tag to download pre-built binaries
		-- build = "nix run .#build-plugin",

		opts = {
			keymap = {
				["<C-p>"] = { "select_prev", "fallback" },
				["<C-n>"] = { "select_next", "fallback" },
				["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
				["<Tab>"] = { "snippet_forward", "fallback" },
				["<S-Tab>"] = { "snippet_backward", "fallback" },
				["<Esc>"] = { "hide", "fallback" },
				["<CR>"] = { "accept", "fallback" },
				["<C-CR>"] = { "select_and_accept", "fallback" },
				["<C-b>"] = { "scroll_documentation_up", "fallback" },
				["<C-f>"] = { "scroll_documentation_down", "fallback" },
			},
			completion = {
				-- Show documentation when selecting a completion item
				documentation = { auto_show = true, auto_show_delay_ms = 0 },
			},
			-- experimental auto-brackets support
			-- accept = { auto_brackets = { enabled = true } }
			-- experimental signature help support
			-- trigger = { signature_help = { enabled = true } }
			sources = {
				per_filetype = {
					codecompanion = { "codecompanion" },
				},
				providers = {
					cmdline = {
						-- ignores cmdline completions when executing shell commands cause WSL hangs
						enabled = function()
							return vim.fn.getcmdtype() ~= ":" or not vim.fn.getcmdline():match("^[%%0-9,'<>%-]*!")
						end,
					},
				},
			},
		},
		-- allows extending the enabled_providers array elsewhere in your config
		-- without having to redefining it
		opts_extend = { "sources.completion.enabled_providers" },
	},
	{
		"neovim/nvim-lspconfig",
		event = "VeryLazy",
	},
	{
		"ibhagwan/fzf-lua",
		opts = {
			-- winopts = {
			-- 	preview = {
			-- 		default = "bat",
			-- 	},
			-- },
		},
		keys = {
			{
				"<leader>b",
				function()
					require("fzf-lua").buffers()
				end,
				desc = "List open buffers",
			},
			{
				"<leader>t",
				function()
					require("fzf-lua").tabs()
				end,
				desc = "List tabs",
			},
			{
				"<leader><leader>",
				function()
					require("fzf-lua").files()
				end,
				desc = "Find files",
			},
			{
				"<leader>?",
				function()
					require("fzf-lua").builtin()
				end,
				desc = "Show fzf-lua builtin search",
			},
			{
				"<leader>p",
				function()
					require("fzf-lua").commands()
				end,
				desc = "Show built-in commands",
			},
			{
				"<leader>s",
				function()
					require("fzf-lua").lsp_document_symbols()
				end,
				desc = "List document symbols",
			},
			{
				"<leader>S",
				function()
					require("fzf-lua").lsp_live_workspace_symbols()
				end,
				desc = "List workspace symbols",
			},
			{
				"<leader>/",
				function()
					-- require("fzf-lua").grep_project()
					require("fzf-lua").live_grep_native()
				end,
				desc = "Grep in project",
			},
			{
				"<leader>d",
				function()
					require("fzf-lua").diagnostics_document()
				end,
				desc = "Show document diagnostics",
			},
			{
				"<leader>D",
				function()
					require("fzf-lua").diagnostics_workspace()
				end,
				desc = "Show workspace diagnostics",
			},
			{
				"<leader>o",
				function()
					require("fzf-lua").oldfiles()
				end,
				desc = "List recently opened files",
			},
			{
				"<leader>r",
				function()
					require("fzf-lua").resume()
				end,
				desc = "Resume last search",
			},
			{
				"<leader>xq",
				function()
					require("fzf-lua").quickfix()
				end,
				desc = "Show quickfix list",
			},
			{
				"<leader>j",
				function()
					require("fzf-lua").jumps()
				end,
				desc = "Show jumplist",
			},
			{
				"<leader>gg",
				function()
					require("fzf-lua").builtin({ query = "^git_" }) -- passed to fzf
				end,
				desc = "Show git related search",
			},
			{
				"grr",
				function()
					require("fzf-lua").lsp_references()
				end,
				desc = "Show LSP references",
			},
			{
				"gd",
				function()
					require("fzf-lua").lsp_definitions()
				end,
				desc = "Go to LSP definitions",
			},
			{
				"<C-x><C-f>",
				function()
					require("fzf-lua").complete_path()
				end,
				desc = "Go to LSP definitions",
				mode = { "x", "i", "v" },
			},
			{
				"<C-x><C-l>",
				function()
					require("fzf-lua").complete_bline()
				end,
				desc = "Go to LSP definitions",
				mode = { "x", "i", "v" },
			},
		},
		cmd = "FzfLua",
	},
	{
		"stevearc/conform.nvim",
		config = function()
			require("conform").setup({
				formatters_by_ft = {
					["*"] = { "codespell" },
					["_"] = { "trim_whitespace" },
					lua = { "stylua" },
					nix = { "nixfmt" },
					python = { "black", "isort" },
					typescript = { "prettierd" },
					typescriptreact = { "prettierd" },
					javascript = { "prettierd" },
					javascriptreact = { "prettierd" },
					json = { "prettierd" },
					html = { "prettierd" },
					-- python = { "ruff_fix", "ruff_format", "ruff_organize_imports" },
					markdown = { "mdformat" },
				},
				format_on_save = function(bufnr)
					if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
						return
					end
					return { timeout_ms = 3000, lsp_fallback = true }
				end,
			})
		end,
		event = "InsertEnter",
	},
	{
		"echasnovski/mini.nvim",
		config = function()
			require("mini.ai").setup({ search_method = "cover_or_nearest" })
			require("mini.pairs").setup()
			require("mini.surround").setup({
				search_method = "cover_or_next",
			})
			require("mini.tabline").setup()
			require("mini.statusline").setup({
				content = {
					active = function()
						local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
						local git = MiniStatusline.section_git({ trunc_width = 40 })
						local diff = MiniStatusline.section_diff({ trunc_width = 75 })
						local diagnostics = MiniStatusline.section_diagnostics({ trunc_width = 75 })
						local lsp = MiniStatusline.section_lsp({ trunc_width = 75 })
						local filename = MiniStatusline.section_filename({ trunc_width = 140 })
						local fileinfo = MiniStatusline.section_fileinfo({ trunc_width = 120 })
						local location = MiniStatusline.section_location({ trunc_width = 75 })
						local search = MiniStatusline.section_searchcount({ trunc_width = 75 })
						local function show_macro_recording()
							local recording_register = vim.fn.reg_recording()
							if recording_register == "" then
								return ""
							else
								return "Recording @" .. recording_register
							end
						end

						return MiniStatusline.combine_groups({
							{ hl = mode_hl, strings = { mode } },
							{ hl = "MiniStatuslineDevinfo", strings = { git, diff, diagnostics, lsp } },
							"%<", -- Mark general truncate point
							{ hl = "MiniStatuslineFilename", strings = { filename } },
							"%=", -- End left alignment
							{ hl = "MiniStatuslineFileinfo", strings = { show_macro_recording() } },
							{ hl = "MiniStatuslineFileinfo", strings = { fileinfo } },
							{ hl = mode_hl, strings = { search, location } },
						})
					end,
				},
			})

			local map_multistep = require("mini.keymap").map_multistep

			-- NOTE: this won't insert tab always, press <C-v><Tab> for that
			local tab_steps = {
				"increase_indent",
				"jump_after_close",
			}
			map_multistep("i", "<Tab>", tab_steps)

			local shifttab_steps = {
				"decrease_indent",
				"jump_before_open",
			}
			map_multistep("i", "<S-Tab>", shifttab_steps)
		end,
		event = "VeryLazy",
	},
	{
		"nvim-treesitter/nvim-treesitter",
		config = function()
			vim.cmd("set runtimepath^=" .. vim.fn.expand("~/.local/share/nvim/nix/nvim-treesitter/parser/"))
			---@diagnostic disable-next-line: missing-fields
			require("nvim-treesitter.configs").setup({
				-- parser_install_dir = "~/.local/share/nvim/nix/nvim-treesitter/parser/parser",
				auto_install = false,
				highlight = {
					enable = true,
					additional_vim_regex_highlighting = false,
				},
			})
		end,
	},
	{ "folke/which-key.nvim", config = true, event = "VeryLazy" },
	{
		"stevearc/oil.nvim",
		opts = {
			delete_to_trash = false,
		},
		cmd = "Oil",
	},
	{
		"nvim-neo-tree/neo-tree.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"MunifTanjim/nui.nvim",
		},
		lazy = false,
		config = function()
			require("neo-tree").setup({
				buffer = {
					follow_current_file = {
						enabled = true,
						leave_dirs_open = false,
					},
				},
				filesystem = {
					follow_current_file = {
						enabled = true,
						leave_dirs_open = false,
					},
					hijack_netrw_behavior = "open_current",
				},
				window = {
					mappings = {
						["Z"] = "expand_all_nodes",
					},
				},
				use_libuv_file_watcher = true,
			})
		end,
		keys = {
			{ "<leader>e", "<cmd>Neotree toggle<CR>", desc = "Toggle Neotree" },
		},
	},
	{
		"tpope/vim-fugitive",
		event = "CmdlineEnter",
	},
	{
		"lewis6991/gitsigns.nvim",
		config = true,
	},
	{
		"folke/persistence.nvim",
		event = "BufReadPre", -- this will only start session saving when an actual file was opened
		config = true,
		init = function()
			-- load the session for the current directory
			vim.keymap.set("n", "<leader>qs", function()
				require("persistence").load()
			end, { desc = "Load session for current directory" })

			-- select a session to load
			vim.keymap.set("n", "<leader>qS", function()
				require("persistence").select()
			end, { desc = "Select a session to load" })

			-- load the last session
			vim.keymap.set("n", "<leader>ql", function()
				require("persistence").load({ last = true })
			end, { desc = "Load the last session" })

			-- stop Persistence => session won't be saved on exit
			vim.keymap.set("n", "<leader>qd", function()
				require("persistence").stop()
			end, { desc = "Stop Persistence (session won't be saved on exit)" })
		end,
	},
	{ "nvim-treesitter/nvim-treesitter-context", config = true },
	-- {
	-- 	"sainnhe/gruvbox-material",
	-- 	lazy = false,
	-- 	priority = 1000,
	-- 	config = function()
	-- 		vim.g.gruvbox_material_enable_italic = true
	-- 		vim.cmd.colorscheme("gruvbox-material")
	-- 	end,
	-- },
	{
		"shaunsingh/nord.nvim",
		version = false,
		lazy = false,
		priority = 1000, -- make sure to load this before all the other start plugins
		-- Optional; default configuration will be used if setup isn't called.
		config = function()
			vim.cmd([[colorscheme nord]])
		end,
	},
	{
		"olimorris/codecompanion.nvim",
		keys = {
			{ "<leader>c", "<Cmd>CodeCompanionChat Toggle<CR>", mode = { "v", "n" } },
		},
		config = function()
			require("codecompanion").setup({
				strategies = {
					chat = {
						adapter = "openai",
					},
					inline = {
						adapter = "openai",
						keymaps = {
							accept_change = {
								modes = { n = "ga" },
								description = "Accept the suggested change",
							},
							reject_change = {
								modes = { n = "gr" },
								description = "Reject the suggested change",
							},
						},
					},
					cmd = {
						adapter = "openai",
					},
				},
			})
		end,
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
	},
	{
		"folke/flash.nvim",
		event = "VeryLazy",
		---@type Flash.Config
		opts = {
			modes = {
				char = {
					enabled = false,
				},
				search = {
					enabled = true,
				},
			},
			label = {
				rainbow = {
					enabled = true,
					-- number between 1 and 9
					shade = 5,
				},
			},
		},
		lazy = false,
		init = function()
			command("FlashToggleSearch", function()
				require("flash").toggle()
			end, { desc = "Toggle flash for forward and backward search" })
		end,
		keys = {
			{
				"s",
				mode = "o",
				function()
					require("flash").remote()
				end,
				desc = "remote flash",
			},
			{
				"m",
				mode = { "n", "x", "o" },
				function()
					require("flash").treesitter()
				end,
				desc = "flash treesitter",
			},
			{
				"x",
				mode = { "o", "x" },
				function()
					require("flash").treesitter_search()
				end,
				desc = "treesitter search",
			},
			{
				"<c-s>",
				mode = { "c" },
				function()
					require("flash").toggle()
				end,
				desc = "toggle flash search",
			},
		},
	},
	{
		"obsidian-nvim/obsidian.nvim",
		version = "*", -- recommended, use latest release instead of latest commit
		lazy = true,
		ft = "markdown",
		-- replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
		event = {
			-- if you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
			-- e.g. "bufreadpre " .. vim.fn.expand "~" .. "/my-vault/*.md"
			-- refer to `:h file-pattern` for more examples
			string.format("bufreadpre %s*.md", os.getenv("OBSIDIAN_HOME")),
			string.format("bufnewfile %s*.md", os.getenv("OBSIDIAN_HOME")),
		},
		dependencies = {
			-- required.
			"nvim-lua/plenary.nvim",

			-- see above for full list of optional dependencies ☝️
		},
		---@module 'obsidian'
		opts = {
			workspaces = {
				{
					name = "personal",
					path = string.format("%s", os.getenv("OBSIDIAN_HOME")),
				},
			},

			daily_notes = {
				-- Optional, if you keep daily notes in a separate directory.
				folder = "Journal",
				-- Optional, if you want to change the date format for the ID of daily notes.
				date_format = "dddd, MMMM Do YYYY",
				time_format = "h:mm:ss a",
				-- Optional, if you want to change the date format of the default alias of daily notes.
				alias_format = "%B %-d, %Y",
				-- Optional, if you want to automatically insert a template from your template directory like 'daily.md'
				template = "daily.md",
			},
			templates = {
				folder = "00-Misc/templates",
				date_format = "%Y-%m-%d",
				time_format = "%H:%M",
				-- A map for custom variables, the key should be the variable and the value a function.
				-- Functions are called with obsidian.TemplateContext objects as their sole parameter.
				-- See: https://github.com/obsidian-nvim/obsidian.nvim/wiki/Template#substitutions
				substitutions = {},

				-- A map for configuring unique directories and paths for specific templates
				--- See: https://github.com/obsidian-nvim/obsidian.nvim/wiki/Template#customizations
				customizations = {},
			},

			picker = {
				-- Set your preferred picker. Can be one of 'telescope.nvim', 'fzf-lua', 'mini.pick' or 'snacks.pick'.
				name = "fzf-lua",
				-- Optional, configure key mappings for the picker. These are the defaults.
				-- Not all pickers support all mappings.
				note_mappings = {
					-- Create a new note from your query.
					new = "<C-x>",
					-- Insert a link to the selected note.
					insert_link = "<C-l>",
				},
				tag_mappings = {
					tag_note = "<C-x>",
				},
			},
		},
		keys = {
			{ "<leader>nn", string.format("<cmd>cd %s | Obsidian quick_switch<cr>", os.getenv("OBSIDIAN_HOME")) },
			{ "<leader>nw", string.format("<cmd>cd %s | Obsidian new<cr>", os.getenv("OBSIDIAN_HOME")) },
			{ "<leader>ne", string.format("<cmd>cd %s | Neotree toggle<cr>", os.getenv("OBSIDIAN_HOME")) },
			{ "<leader>ns", string.format("<cmd>cd %s | Obsidian search<cr>", os.getenv("OBSIDIAN_HOME")) },
			{ "<leader>nt", string.format("<cmd>cd %s | Obsidian tags<cr>", os.getenv("OBSIDIAN_HOME")) },
			{ "<leader>nd", string.format("<cmd>cd %s | Obsidian dailies<cr>", os.getenv("OBSIDIAN_HOME")) },
		},
	},
	{
		"meanderingprogrammer/render-markdown.nvim",
		ft = { "markdown", "codecompanion" },
		opts = {
			heading = {
				enabled = true,
				atx = false,
			},
		},
	},
}

return plugins
