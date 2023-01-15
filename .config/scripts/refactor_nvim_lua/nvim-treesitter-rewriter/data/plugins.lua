return require("packer").startup({
	function(use)
		-- Packer can manage itself
		use({ "wbthomason/packer.nvim", opt = true })
		use({ "christoomey/vim-tmux-navigator" })
		-- repeats whole commands, not just last component of command
		-- try ys_{ then . without this, won't work properly
		use({ "tpope/vim-repeat" })
		use({ "mbbill/undotree", cmd = { "UndotreeToggle", "UndotreeFocus", "UndotreeHide", "UndotreeShow" } })
		use({
			"jpalardy/vim-slime",
			keys = { { "n", "<C-c><C-c>" }, { "v", "<C-c><C-c>" }, { "n", "<C-c>v" } },
			config = function()
				vim.g.slime_target = "tmux"
				vim.g.slime_paste_file = vim.fn.tempname()
				vim.g.slime_default_config = {
					-- need require inside or will fail
					socket_name = require("utils").split(os.getenv("TMUX"), ",")[1],
					target_pane = "{next}",
				}
			end,
		})
		use({
			"tpope/vim-fugitive",
		})
		use({
			"lewis6991/gitsigns.nvim",
			config = function()
				require("gitsigns").setup({
					on_attach = require("mappings").on_attach_gitsigns,
				})
			end,
		})
		use({
			"hrsh7th/nvim-cmp",
			event = { "InsertEnter", "CmdlineEnter" },
			requires = {
				{ "hrsh7th/cmp-buffer", after = "nvim-cmp" },
				{ "hrsh7th/cmp-path", after = "nvim-cmp" },
				{ "hrsh7th/cmp-cmdline", after = "nvim-cmp" },
				{ "saadparwaiz1/cmp_luasnip", after = "nvim-cmp" },
				{ "hrsh7th/cmp-nvim-lsp", after = "nvim-cmp" },
			},
			config = function()
				require("config.nvim-cmp")
			end,
		})
		use({
			"L3MON4D3/LuaSnip",
			module = "luasnip",
			config = function()
				require("luasnip").config.setup({
					store_selection_keys = require("mappings").luasnip.store_selection_keys,
					history = true,
				})
				require("luasnip.loaders.from_snipmate").lazy_load() -- looks for snippets/ in rtp
				require("luasnip.loaders.from_lua").lazy_load()
				require("luasnip").filetype_extend("lua", { "luasnip", "luanvim" })
			end,
		})
		-- this sequencing is for mason-lspconfig
		use({
			"williamboman/mason.nvim",
			ft = { "lua", "python", "sh", "json", "c", "css", "astro", "go", "html" },
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
		})
		use({
			"williamboman/mason-lspconfig.nvim",
			after = "mason.nvim",
			config = function()
				require("mason-lspconfig").setup()
			end,
		})
		use({
			"neovim/nvim-lspconfig",
			after = "mason-lspconfig.nvim",
			config = function()
				require("lspsetup")
			end,
		})
		use({
			"jose-elias-alvarez/null-ls.nvim",
			after = "nvim-lspconfig",
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
		})
		use({
			"glepnir/lspsaga.nvim",
			after = "nvim-lspconfig",
			branch = "main",
			config = function()
				local saga = require("lspsaga")
				saga.init_lsp_saga({
					-- your configuration
				})
			end,
		})
		use({
			"nvim-treesitter/nvim-treesitter",
			run = ":TSUpdate",
			config = function()
				require("nvim-treesitter.configs").setup({
					-- A list of parser names, or "all"
					ensure_installed = { "python", "lua", "norg", "vim" },
					highlight = { -- Be sure to enable highlights if you haven't!
						enable = true,
					},
					indent = {
						enable = true,
						disable = { "python", "css" },
					},
					incremental_selection = {
						enable = true,
						keymaps = require("mappings").nvim_treesitter.incremental_selection.keymaps,
					},

					-- Install parsers synchronously (only applied to `ensure_installed`)
					sync_install = false,

					-- Automatically install missing parsers when entering buffer
					auto_install = true,
				})
			end,
		})
		use({
			"nvim-telescope/telescope.nvim",
			requires = {
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
					"ahmedkhalf/project.nvim",
					opt = true,
					module = "project_nvim",
					config = function()
						require("project_nvim").setup({
							show_hidden = true,
							manual_mode = true,
						})
					end,
				},
				use({ opt = true, "nvim-telescope/telescope-fzf-native.nvim", run = "make" }),
			},
			cmd = { "Telescope", "Legendary" },
			module = "telescope", -- require telescope runs before command
			after = { "telescope-fzf-native.nvim", "project.nvim" },
			config = function()
				require("config.telescope")
			end,
		})
		use({ "folke/neodev.nvim", module = "neodev" })
		use({
			"catppuccin/nvim",
			as = "catppuccin",
			config = function()
				require("catppuccin").setup({
					dim_inactive = {
						enabled = true,
						shade = "dark",
						percentage = -1.15,
					},
				})
				vim.cmd("colorscheme catppuccin")
			end,
		})
		use({ "ggandor/leap.nvim" })
		use({
			"MunifTanjim/nui.nvim",
			cmd = "Neotree",
		})
		use({
			"nvim-neo-tree/neo-tree.nvim",
			requires = {
				"nvim-lua/plenary.nvim",
				"kyazdani42/nvim-web-devicons", -- not strictly required, but recommended
			},
			after = {
				"nui.nvim",
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
		})
		use({ "lewis6991/impatient.nvim" })
		use({
			"folke/which-key.nvim",
			config = function()
				require("which-key").setup({})
			end,
		})
		use({
			"tweekmonster/startuptime.vim",
			cmd = "StartupTime",
		})
		use({
			"feline-nvim/feline.nvim",
			config = function()
				--don't show full statusline in neo-tree window
				table.insert(
					require("feline.defaults").statusline.force_inactive.default_value.filetypes,
					"^neo%-tree$"
				)
				--show actual mode instead of icon
				require("feline.default_components").statusline.icons.active[1][2] = {
					provider = "vi_mode",
					hl = function()
						return {
							name = require("feline.providers.vi_mode").get_mode_highlight_name(),
							fg = require("feline.providers.vi_mode").get_mode_color(),
							style = "bold",
						}
					end,
					right_sep = " ",
					icon = "",
				}
				--so no need to setup anything since i changed the values in the above
				require("feline").setup({})
			end,
		})
		use({
			"lukas-reineke/indent-blankline.nvim",
			config = function()
				require("indent_blankline").setup({
					filetype_exclude = { "neo-tree" },
				})
			end,
		})
		use({ "nvim-treesitter/nvim-treesitter-textobjects", after = "nvim-treesitter" })
		use({
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
			end,
		})
		use({ "machakann/vim-sandwich" })
		use({
			"nvim-treesitter/nvim-treesitter-context",
			config = function()
				require("treesitter-context").setup({
					separator = "-",
				})
			end,
		})
		use({
			"akinsho/toggleterm.nvim",
			cmd = "ToggleTerm",
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
			use({
				"python-rope/ropevim",
				ft = "python",
			}),
		})
		use({
			"/home/alf/Documents/Forks/zk-nvim",
			cmd = {
				"ZkIndex",
				"ZkNew",
				"ZkNewFromTitleSelection",
				"ZkNewFromContentSelection",
				"ZkCd",
				"ZkNotes",
				"ZkBacklinks",
				"ZkLinks",
				"ZkMatch",
				"ZkTags",
				"ZkDeleteNotes",
			},
			config = function()
				require("zk").setup({
					picker = "telescope",
					lsp = {
						config = {
							on_attach = require("mappings").on_attach_mappings,
							-- etc, see `:h vim.lsp.start_client()`
						},
					},
				})
				require("config.zk")
			end,
		})

		use({
			"mrjones2014/legendary.nvim",
			-- sqlite is only needed if you want to use frecency sorting
			requires = "kkharji/sqlite.lua",
			cmd = "Legendary",
			after = "telescope.nvim",
			config = function()
				require("legendary").setup({})
			end,
		})
		use({
			"mfussenegger/nvim-dap",
			config = function()
				require("dapsetup")
			end,
		})
		use({
			"rcarriga/nvim-dap-ui",
			after = "nvim-dap",
			module = "dapui",
			config = function()
				require("dapui").setup()
			end,
		})
		use({ "jbyuki/one-small-step-for-vimkind", module = "osv" })
		use({ "/home/alf/Housekeeping/dotfiles/.config/scripts/refactor_nvim_lua/nvim-treesitter-rewriter" })
		use({
			"ray-x/go.nvim",
			ft = "go",
			config = function()
				require("go").setup()
			end,
		})
		use({ "nvim-treesitter/playground", cmd = "TSPlaygroundToggle" })
	end,
})
