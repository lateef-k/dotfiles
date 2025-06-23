-- Plugin specs
local plugins = {
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
		lazy = false, -- lazy loading handled internally
		-- optional: provides snippets for the snippet source
		dependencies = "rafamadriz/friendly-snippets",

		version = "*",

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
			-- experimental auto-brackets support
			-- accept = { auto_brackets = { enabled = true } }
			-- experimental signature help support
			-- trigger = { signature_help = { enabled = true } }
			sources = {
				per_filetype = {
					codecompanion = { "codecompanion" },
				},
			},
		},
		-- allows extending the enabled_providers array elsewhere in your config
		-- without having to redefining it
		opts_extend = { "sources.completion.enabled_providers" },
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			local lspconfig = require("lspconfig")
			local servers = {
				"pyright",
				"nixd",
				"lua_ls",
				"bashls",
				"ts_ls",
			}
			for _, lsp in ipairs(servers) do
				lspconfig[lsp].setup({})
			end

			-- print(vim.inspect(lspconfig["ruff_lsp"]))
		end,
		event = "VeryLazy",
	},
	{
		"ibhagwan/fzf-lua",
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
					require("fzf-lua").grep_project()
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
					typescript = { "prettier" },
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
			require("mini.statusline").setup()

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
	-- {
	-- 	"CopilotC-Nvim/CopilotChat.nvim",
	-- 	init = function()
	-- 		-- Define a function to toggle CopilotChat
	--
	-- 		-- Set the keybinding to call the toggle function
	-- 		vim.keymap.set({ "n", "v" }, "<leader>c", function()
	-- 			local copilot_chat_win = nil
	-- 			for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
	-- 				local buf = vim.api.nvim_win_get_buf(win)
	-- 				local filetype = vim.bo[buf].filetype
	-- 				if filetype == "copilot-chat" then
	-- 					copilot_chat_win = win
	-- 				end
	-- 			end
	-- 			if copilot_chat_win ~= nil then
	-- 				vim.api.nvim_win_close(copilot_chat_win, true)
	-- 			else
	-- 				vim.cmd("CopilotChat") -- Open CopilotChat if it's closed
	-- 			end
	-- 		end, { noremap = true, silent = true })
	-- 	end,
	-- 	config = {
	-- 		window = {
	-- 			layout = "float",
	-- 		},
	-- 		-- Define keymap for starting CopilotChat
	-- 		mappings = {
	-- 			complete = {
	-- 				detail = "Use @<Tab> or /<Tab> for options.",
	-- 				insert = "<Tab>",
	-- 			},
	-- 			close = {
	-- 				normal = "q",
	-- 				insert = "<C-c>",
	-- 			},
	-- 			reset = {
	-- 				normal = "<C-r>",
	-- 			},
	-- 			submit_prompt = {
	-- 				normal = "<CR>",
	-- 				insert = "<C-s>",
	-- 			},
	-- 			accept_diff = {
	-- 				normal = "<C-y>",
	-- 				insert = "<C-y>",
	-- 			},
	-- 			yank_diff = {
	-- 				normal = "gy",
	-- 				register = '"',
	-- 			},
	-- 			show_diff = {
	-- 				normal = "gd",
	-- 			},
	-- 			show_info = {
	-- 				normal = "gp",
	-- 			},
	-- 			show_context = {
	-- 				normal = "gs",
	-- 			},
	-- 		},
	-- 	},
	-- 	build = "make tiktoken",
	-- 	dependencies = { { "nvim-lua/plenary.nvim" } },
	-- },
	-- {
	-- 	"zbirenbaum/copilot.lua",
	-- 	config = true,
	-- 	panel = {
	-- 		enabled = false,
	-- 	},
	-- 	suggestion = {
	-- 		enabled = true,
	-- 		auto_trigger = false,
	-- 		hide_during_completion = false,
	-- 		debounce = 75,
	-- 		keymap = {
	-- 			accept = "<M-l>",
	-- 			accept_word = false,
	-- 			accept_line = false,
	-- 			next = "<M-]>",
	-- 			prev = "<M-[>",
	-- 			dismiss = "<C-]>",
	-- 		},
	-- 	},
	-- },
	{
		"tpope/vim-fugitive",
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
	{
		"sainnhe/gruvbox-material",
		lazy = false,
		priority = 1000,
		config = function()
			vim.g.gruvbox_material_enable_italic = true
			vim.cmd.colorscheme("gruvbox-material")
		end,
	},
	{
		"mbbill/undotree",
	},
	-- {
	-- 	"neanias/everforest-nvim",
	-- 	version = false,
	-- 	lazy = false,
	-- 	priority = 1000, -- make sure to load this before all the other start plugins
	-- 	-- Optional; default configuration will be used if setup isn't called.
	-- 	config = function()
	-- 		require("everforest").setup({
	-- 			background = "hard",
	-- 			italics = true,
	-- 			ui_contrast = "low",
	-- 		})
	-- 		vim.cmd([[colorscheme everforest]])
	-- 	end,
	-- },
	--
	{
		"olimorris/codecompanion.nvim",
		keys = {
			{ "<leader>c", "<Cmd>CodeCompanionChat Toggle<CR>" },
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
		},
		keys = {
			{
				"s",
				mode = "o",
				function()
					require("flash").remote()
				end,
				desc = "Remote Flash",
			},
			{
				"x",
				mode = { "n", "x", "o" },
				function()
					require("flash").treesitter()
				end,
				desc = "Flash Treesitter",
			},
			{
				"X",
				mode = { "o", "x" },
				function()
					require("flash").treesitter_search()
				end,
				desc = "Treesitter Search",
			},
			{
				"<c-s>",
				mode = { "c" },
				function()
					require("flash").toggle()
				end,
				desc = "Toggle Flash Search",
			},
		},
	},
}

return plugins
