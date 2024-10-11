--
--                                                 *grr* *gra* *grn* *i_CTRL-S*
-- Some keymaps are created unconditionally when Nvim starts:
-- - "grn" is mapped in Normal mode to |vim.lsp.buf.rename()|
-- - "gra" is mapped in Normal and Visual mode to |vim.lsp.buf.code_action()|
-- - "grr" is mapped in Normal mode to |vim.lsp.buf.references()|
-- - CTRL-S is mapped in Insert mode to |vim.lsp.buf.signature_help()|
--
--
-- - 'omnifunc' is set to |vim.lsp.omnifunc()|, use |i_CTRL-X_CTRL-O| to trigger
--   completion.
-- - 'tagfunc' is set to |vim.lsp.tagfunc()|. This enables features like
--   go-to-definition, |:tjump|, and keymaps like |CTRL-]|, |CTRL-W_]|,
--   |CTRL-W_}| to utilize the language server.
-- - 'formatexpr' is set to |vim.lsp.formatexpr()|, so you can format lines via
--   |gq| if the language server supports it.
--   - To opt out of this use |gw| instead of gq, or clear 'formatexpr' on |LspAttach|.
-- - |K| is mapped to |vim.lsp.buf.hover()| unless |'keywordprg'| is customized or
--   a custom keymap for `K` exists.
--
--
-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end

vim.opt.cmdheight = 0
vim.opt.undofile = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.smartcase = true
vim.opt.smartindent = true
vim.opt.clipboard = "unnamedplus"

vim.cmd("colorscheme retrobox")

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

map({ "i", "t" }, "jk", "<Esc>", opts)
map({ "i", "t" }, "kj", "<Esc>", opts)
map("n", "]b", "<cmd>bnext<CR>")
map("n", "[b", "<cmd>bprevious<CR>")
map("n", "]q", "<cmd>cnext<CR>")
map("n", "[q", "<cmd>cprevious<CR>")

vim.opt.rtp:prepend(lazypath)

-- Set leader key
vim.g.mapleader = " "

-- Set options
vim.opt.grepprg = "rg --vimgrep --smart-case"

-- AutoCmd
vim.api.nvim_create_autocmd("FileType", {
	pattern = "nix",
	command = "setlocal tabstop=2 shiftwidth=2 softtabstop=2",
})

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
		--   -- Below are the default binds, setting any value in these tables will override
		--   -- the defaults, to inherit from the defaults change [1] from `false` to `true`
		--   builtin = {
		--     false,          -- do not inherit from defaults
		--     -- neovim `:tmap` mappings for the fzf win
		--     ["<F1>"]        = "toggle-help",
		--     ["<F2>"]        = "toggle-fullscreen",
		--     -- Only valid with the 'builtin' previewer
		--     ["<F3>"]        = "toggle-preview-wrap",
		--     ["<F4>"]        = "toggle-preview",
		--     -- Rotate preview clockwise/counter-clockwise
		--     ["<F5>"]        = "toggle-preview-ccw",
		--     ["<F6>"]        = "toggle-preview-cw",
		--     ["<S-down>"]    = "preview-page-down",
		--     ["<S-up>"]      = "preview-page-up",
		--     ["<S-left>"]    = "preview-page-reset",
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
		--     -- Only valid with fzf previewers (bat/cat/git/etc)
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
			},
			{
				"<leader><leader>",
				function()
					require("fzf-lua").files()
				end,
			},
			{
				"<leader>?",
				function()
					require("fzf-lua").builtin()
				end,
			},
			{
				"<leader>s",
				function()
					require("fzf-lua").lsp_document_symbols()
				end,
			},
			{
				"<leader>S",
				function()
					require("fzf-lua").lsp_workspace_symbols()
				end,
			},
			{
				"<leader>/",
				function()
					require("fzf-lua").grep_project()
				end,
			},
			{
				"<leader>d",
				function()
					require("fzf-lua").diagnostics_document()
				end,
			},
			{
				"<leader>D",
				function()
					require("fzf-lua").diagnostics_workspace()
				end,
			},
			{
				"<leader>o",
				function()
					require("fzf-lua").oldfiles()
				end,
			},
			{
				"<leader>r",
				function()
					require("fzf-lua").resume()
				end,
			},
			{
				"<leader>xq",
				function()
					require("fzf-lua").quickfix()
				end,
			},
			{
				"<leader>j",
				function()
					require("fzf-lua").jumplist()
				end,
			},
			{
				"grr",
				function()
					require("fzf-lua").lsp_references()
				end,
			},
			{
				"gd",
				function()
					require("fzf-lua").lsp_definitions()
				end,
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
		"zbirenbaum/copilot.lua",
		config = true,
	},
	{
		"tpope/vim-fugitive",
	},
	{
		"lewis6991/gitsigns.nvim",
		config = true,
	},
}

-- Setup lazy.nvim
require("lazy").setup(plugins)
