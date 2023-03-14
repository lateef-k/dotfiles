local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

local plugins = {
	{ "christoomey/vim-tmux-navigator" },
	{ "tpope/vim-repeat" },
	{
		"mbbill/undotree",
		cmd = { "UndotreeToggle", "UndotreeFocus", "UndotreeHide", "UndotreeShow" },
	},
	{
		"tpope/vim-fugitive",
	},
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup({
				on_attach = require("mappings").on_attach_gitsigns,
			})
		end,
	},
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			{ "hrsh7th/cmp-buffer", after = "nvim-cmp" },
			{ "hrsh7th/cmp-path", after = "nvim-cmp" },
			{ "hrsh7th/cmp-cmdline", after = "nvim-cmp" },
			{ "saadparwaiz1/cmp_luasnip", after = "nvim-cmp" },
			{ "hrsh7th/cmp-nvim-lsp", after = "nvim-cmp" },
		},
		config = function()
			require("config.nvim-cmp")
		end,
	},
	{
		"L3MON4D3/LuaSnip",
		config = function()
			require("luasnip").config.setup({
				store_selection_keys = require("mappings").luasnip.store_selection_keys,
				history = true,
			})
			require("luasnip.loaders.from_snipmate").lazy_load() -- looks for snippets/ in rtp
			require("luasnip.loaders.from_lua").lazy_load()
			require("luasnip").filetype_extend("lua", { "luasnip", "luanvim" })
			require("luasnip").filetype_extend("telekasten", { "markdown" })
		end,
	},
	{
		"williamboman/mason.nvim",
		ft = {
			"lua",
			"python",
			"sh",
			"json",
			"c",
			"css",
			"astro",
			"go",
			"html",
			"markdown",
			"svelte",
			"typescript",
		},
		cmd = {
			"Mason",
			"MasonInstall",
			"MasonUninstall",
			"MasonUninstallAll",
			"MasonLog",
			"LspInstall",
			"LspUninstall", --mason-lspconfig commands
			"LspLog",
			"LspInfo",
			"LspStart",
			"LspStop",
			"LspRestart", --lspconfig commands
		},
		config = function()
			require("mason").setup()
		end,
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			require("setup.lsp")
		end,
	},
	{
		"jose-elias-alvarez/null-ls.nvim",
		config = function()
			require("null-ls").setup({
				sources = {
					require("null-ls").builtins.formatting.black,
					require("null-ls").builtins.formatting.isort,
					require("null-ls").builtins.diagnostics.flake8,
					require("null-ls").builtins.formatting.prettier,
					require("null-ls").builtins.formatting.stylua,
				},
				on_attach = require("mappings").on_attach_mappings,
			})
		end,
	},
	{
		"glepnir/lspsaga.nvim",
		after = "nvim-lspconfig",
		branch = "main",
		config = function()
			local saga = require("lspsaga")
			saga.setup({
				-- your configuration
				rename = {
					quit = "q",
				},
			})
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
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
			})
		end,
	},
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			{ "nvim-lua/plenary.nvim" },
			{
				"kyazdani42/nvim-web-devicons",
				config = function()
					require("nvim-web-devicons").setup({
						default = true,
					})
				end,
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
		cmd = { "Telescope", "Legendary" },
		config = function()
			require("config.telescope")
		end,
	},
	{ "folke/neodev.nvim" },
	{
		"rebelot/kanagawa.nvim",
		config = function()
			require("kanagawa").setup({
				dimInactive = false, -- dim inactive window `:h hl-NormalNC`
			})
			vim.cmd("colorscheme kanagawa")
		end,
	},
	{ "ggandor/leap.nvim" },
	{
		"MunifTanjim/nui.nvim",
		cmd = "Neotree",
	},
	{
		"nvim-neo-tree/neo-tree.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"kyazdani42/nvim-web-devicons", -- not strictly required, but recommended
		},
		config = function()
			vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])
			require("neo-tree").setup({
				source_selector = {
					winbar = false,
					statusline = false,
				},
				window = {
					position = "left",
					width = 30,
				},
				filesystem = {
					follow_current_file = true,
					use_libuv_file_watcher = true,
				},
			})
		end,
	},
	{ "lewis6991/impatient.nvim" },
	{
		"folke/which-key.nvim",
		config = function()
			require("which-key").setup({})
		end,
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		config = function()
			require("indent_blankline").setup({
				filetype_exclude = { "neo-tree" },
			})
		end,
	},
	{
		"echasnovski/mini.nvim",
		config = function()
			local spec_treesitter = require("mini.ai").gen_spec.treesitter
			require("mini.ai").setup({
				n_lines = 10000,
				mappings = require("mappings").mini.ai,
				custom_textobjects = {
					a = spec_treesitter({ a = "@parameter.outer", i = "@parameter.inner" }), -- overide argument text object
					f = spec_treesitter({ a = "@function.outer", i = "@function.inner" }),
					o = spec_treesitter({
						a = { "@conditional.outer", "@loop.outer" },
						i = { "@conditional.inner", "@loop.inner" },
					}),
					c = spec_treesitter({
						a = { "@call.outer" },
						i = { "@call.inner" },
					}),
					C = spec_treesitter({
						a = { "@class.outer" },
						i = { "@class.inner" },
					}),
				},
			})
			require("mini.comment").setup()
			require("mini.indentscope").setup({
				draw = {
					delay = 0,
					animation = require("mini.indentscope").gen_animation.none(),
				},
			})
			require("mini.pairs").setup()
			require("mini.pairs").unmap("i", "`", "``")
			require("mini.pairs").unmap("i", "'", "''")
			require("mini.surround").setup()
			require("mini.sessions").setup()
			require("mini.statusline").setup({
				content = {
					active = function()
						local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
						local git = MiniStatusline.section_git({ trunc_width = 75 })
						local diagnostics = MiniStatusline.section_diagnostics({ trunc_width = 75 })
						local filename = MiniStatusline.section_filename({ trunc_width = 140 })
						local fileinfo = MiniStatusline.section_fileinfo({ trunc_width = 120 })
						local location = MiniStatusline.section_location({ trunc_width = 75 })

						local session = vim.v.this_session
						if session ~= "" then
							for component in session:gmatch("[^%%]+") do
								session = "[Session: " .. component .. " ]"
							end
						else
							session = "NO SESSION"
						end

						return MiniStatusline.combine_groups({
							{ hl = mode_hl, strings = { mode } },
							{ hl = "MiniStatuslineDevinfo", strings = { git, diagnostics } },
							"%<", -- Mark general truncate point
							{ hl = "MiniStatuslineFilename", strings = { filename } },
							"%=", -- End left alignment
							{
								hl = "MiniStatuslineDevinfo",
								strings = { session },
							},
							{ hl = "MiniStatuslineFileinfo", strings = { fileinfo } },
							{ hl = mode_hl, strings = { location } },
						})
					end,
				},
			})
			vim.cmd([[doautocmd WinEnter]]) -- not triggering otherwise
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
		"akinsho/toggleterm.nvim",
		keys = {
			{ "n", "<C-F>" },
			{ "i", "<C-F>" },
		},
		config = function()
			require("toggleterm").setup({
				open_mapping = require("mappings").toggleterm.open_mapping,
				hide_numbers = false,
				shade_terminals = false,
				direction = "float",
			})
		end,
	},
	{
		"python-rope/ropevim",
		ft = "python",
	},
	{
		"mrjones2014/legendary.nvim",
		-- sqlite is only needed if you want to use frecency sorting
		dependencies = "kkharji/sqlite.lua",
		cmd = "Legendary",
		config = function()
			require("legendary").setup({})
		end,
	},
	{
		"mfussenegger/nvim-dap",
		config = function()
			require("setup.dap")
		end,
	},
	{
		"rcarriga/nvim-dap-ui",
		config = function()
			require("dapui").setup()
		end,
	},
	{ "jbyuki/one-small-step-for-vimkind" },
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
	{ "bfredl/nvim-luadev", ft = "lua" },
	{ "stevearc/dressing.nvim" },
	{
		"jose-elias-alvarez/typescript.nvim",
		config = function()
			require("typescript").setup({
				disable_commands = false, -- prevent the plugin from creating Vim commands
				debug = false, -- enable debug logging for commands
				go_to_source_definition = {
					fallback = true, -- fall back to standard LSP definition on failure
				},
				server = { -- pass options to lspconfig's setup method
					on_attach = require("mappings").on_attach_mappings,
					capabilities = require("config.nvim-cmp"),
				},
			})
		end,
	},
}

require("lazy").setup(plugins)
