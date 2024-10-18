-- Plugin specs
local plugins = {
	{ "aserowy/tmux.nvim", config = true, event = "VeryLazy" },
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
	{ -- optional completion source for require statements and module annotations
		"hrsh7th/nvim-cmp",
		---@diagnostic disable-next-line: redefined-local
		opts = function(_, opts)
			opts.sources = opts.sources or {}
			table.insert(opts.sources, {
				name = "lazydev",
				group_index = 0, -- set group index to 0 to skip loading LuaLS completions
			})
		end,
	},
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-nvim-lua",
		},
		event = "InsertEnter",
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			cmp.setup({
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<CR>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							if luasnip.expandable() then
								luasnip.expand()
							else
								cmp.confirm({
									select = true,
								})
							end
						else
							fallback()
						end
					end),
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.locally_jumpable(1) then
							luasnip.jump(1)
						else
							fallback()
						end
					end, { "i", "s" }),
					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.locally_jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
				}),
				sources = cmp.config.sources({
					{ name = "path" },
					{ name = "nvim_lsp" },
					{ name = "nvim_lsp_signature_help" },
					{ name = "nvim_lua" },
					{ name = "luasnip" },
					{ name = "buffer", option = { get_bufnrs = vim.api.nvim_list_bufs } },
				}),
				experimental = {
					ghost_text = true,
				},
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			local lsp_capabilities = require("cmp_nvim_lsp").default_capabilities()
			local lspconfig = require("lspconfig")
			local servers = {
				"pyright",
				"nixd",
				"lua_ls",
				"bashls",
			}
			for _, lsp in ipairs(servers) do
				lspconfig[lsp].setup({
					capabilities = lsp_capabilities,
				})
			end
			lspconfig.pyright.setup({})
			lspconfig.nixd.setup({})
		end,
		event = "VeryLazy",
	},
	{
		"ibhagwan/fzf-lua",
		-- keymap = {
		--   -- below are the default binds, setting any value in these tables will override
		--   -- the defaults, to inherit from the defaults change [1] from `false` to `true`
		--   builtin = {
		--     false,          -- do not inherit from defaults
		--     -- neovim `:tmap` mappings for the fzf win
		--     ["<f1>"]        = "toggle-help",
		--     ["<f2>"]        = "toggle-fullscreen",
		--     -- only valid with the 'builtin' previewer
		--     ["<f3>"]        = "toggle-preview-wrap",
		--     ["<f4>"]        = "toggle-preview",
		--     -- rotate preview clockwise/counter-clockwise
		--     ["<f5>"]        = "toggle-preview-ccw",
		--     ["<f6>"]        = "toggle-preview-cw",
		--     ["<s-down>"]    = "preview-page-down",
		--     ["<s-up>"]      = "preview-page-up",
		--     ["<s-left>"]    = "preview-page-reset",
		--   },
		--   fzf = {
		--     false,          -- do not inherit from defaults
		--     -- fzf '--bind=' options
		--     ["ctrl-z"]      = "abort",
		--     ["ctrl-u"]      = "unix-line-discard",
		--     ["ctrl-f"]      = "half-page-down",
		--     ["ctrl-b"]      = "half-page-up",
		--     ["ctrl-a"]      = "beginning-of-line",
		--     ["ctrl-e"]      = "end-of-line",
		--     ["alt-a"]       = "toggle-all",
		--     -- only valid with fzf previewers (bat/cat/git/etc)
		--     ["f3"]          = "toggle-preview-wrap",
		--     ["f4"]          = "toggle-preview",
		--     ["shift-down"]  = "preview-page-down",
		--     ["shift-up"]    = "preview-page-up",
		--   },
		-- }
		keys = {
			{
				"<leader>b",
				function()
					require("fzf-lua").buffers()
				end,
				desc = "List open buffers",
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
					require("fzf-lua").lsp_workspace_symbols()
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
					require("fzf-lua").jumplist()
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
					python = { "isort", "black" },
					markdown = { "mdformat" },
				},
				format_on_save = function(bufnr)
					if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
						return
					end
					return { timeout_ms = 500, lsp_fallback = true }
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
				use_icons = false,
			})
		end,
		event = "VeryLazy",
	},
	{
		"L3MON4D3/LuaSnip",
		dependencies = { "rafamadriz/friendly-snippets" },
		event = "InsertEnter",
		config = function()
			require("luasnip.loaders.from_vscode").lazy_load()
		end,
	},
	{ "nvim-treesitter/nvim-treesitter", dev = true },
	{ "folke/which-key.nvim", config = true, event = "VeryLazy" },
	{
		"nvim-neo-tree/neo-tree.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"MunifTanjim/nui.nvim",
		},
		config = true,
		keys = {
			{ "<leader>e", "<cmd>Neotree toggle<CR>", desc = "Toggle Neotree" },
		},
	},
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		init = function()
			-- Define a function to toggle CopilotChat

			-- Set the keybinding to call the toggle function
			vim.keymap.set({ "n", "v" }, "<leader>c", function()
				local copilot_chat_win = nil
				for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
					local buf = vim.api.nvim_win_get_buf(win)
					local filetype = vim.bo[buf].filetype
					if filetype == "copilot-chat" then
						copilot_chat_win = win
					end
				end
				if copilot_chat_win ~= nil then
					vim.api.nvim_win_close(copilot_chat_win, true)
				else
					vim.cmd("CopilotChat") -- Open CopilotChat if it's closed
				end
			end, { noremap = true, silent = true })
		end,
		config = {

			-- Define keymap for starting CopilotChat
			mappings = {
				complete = {
					detail = "Use @<Tab> or /<Tab> for options.",
					insert = "<Tab>",
				},
				close = {
					normal = "q",
					insert = "<C-c>",
				},
				reset = {
					normal = "<C-r>",
				},
				submit_prompt = {
					normal = "<CR>",
					insert = "<C-s>",
				},
				accept_diff = {
					normal = "<C-y>",
					insert = "<C-y>",
				},
				yank_diff = {
					normal = "gy",
					register = '"',
				},
				show_diff = {
					normal = "gd",
				},
				show_system_prompt = {
					normal = "gp",
				},
				show_user_selection = {
					normal = "gs",
				},
			},
		},
		build = "make tiktoken",
	},
	{
		"zbirenbaum/copilot.lua",
		config = true,
		-- panel = {
		--   enabled = true,
		--   auto_refresh = false,
		--   keymap = {
		--     jump_prev = "[[",
		--     jump_next = "]]",
		--     accept = "<CR>",
		--     refresh = "gr",
		--     open = "<M-CR>"
		--   },
		--   layout = {
		--     position = "bottom", -- | top | left | right
		--     ratio = 0.4
		--   },
		-- },
		-- suggestion = {
		--   enabled = true,
		--   auto_trigger = false,
		--   hide_during_completion = true,
		--   debounce = 75,
		--   keymap = {
		--     accept = "<M-l>",
		--     accept_word = false,
		--     accept_line = false,
		--     next = "<M-]>",
		--     prev = "<M-[>",
		--     dismiss = "<C-]>",
		--   },
		-- },
	},
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
}

return plugins
