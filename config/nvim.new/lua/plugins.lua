return {
	{
		"zbirenbaum/copilot.lua",
		opts = {
			suggestion = {
				enabled = true,
				auto_trigger = false,
				keymap = {
					accept = "<M-CR>",
					accept_word = false,
					accept_line = false,
					next = "<M-]>",
					prev = "<M-[>",
					dismiss = "<M-c>",
				},
			},
		},
		cmd = "Copilot",
	},
	{
		"ibhagwan/fzf-lua",
		-- optional for icon support
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			-- calling `setup` is optional for customization
			require("fzf-lua").setup({})
		end,
		keys = {
			{ "<leader>,", "<cmd>lua require('fzf-lua').buffers()<cr>", desc = "Switch Buffer" },
			{ "<leader>/", "<cmd>lua require('fzf-lua').grep({ search = '' })<cr>", desc = "Grep (root dir)" },
			{ "<leader>:", "<cmd>lua require('fzf-lua').command_history()<cr>", desc = "Command History" },
			{ "<leader><space>", "<cmd>lua require('fzf-lua').files()<cr>", desc = "Find Files (root dir)" },
			-- { "<leader>fb", "<cmd>lua require('fzf-lua').buffers()<cr>", desc = "Buffers" }, -- redundent
			{ "<leader>fz", "<cmd>FzfLua<cr>", desc = "Open Fzf lua" },
			{
				"<leader>fc",
				"<cmd>lua require('fzf-lua').files({ cwd = '~/Housekeeping/dotfiles/config/' })<cr>",
				desc = "Find Config File",
			},
			{
				"<leader>ff",
				"<cmd>lua require('fzf-lua').files({ cwd = vim.fn.getcwd() })<cr>",
				desc = "Find Files (cwd)",
			},
			{ "<leader>fr", "<cmd>lua require('fzf-lua').oldfiles()<cr>", desc = "Recent" },
			{
				"<leader>fR",
				"<cmd>lua require('fzf-lua').oldfiles({ cwd = vim.fn.getcwd() })<cr>",
				desc = "Recent (cwd)",
			},
			{ "<leader>gb", "<cmd>lua require('fzf-lua').git_bcommits()<CR>", desc = "commits" },
			{ "<leader>gc", "<cmd>lua require('fzf-lua').git_commits()<CR>", desc = "commits" },
			{ "<leader>gs", "<cmd>lua require('fzf-lua').git_status()<CR>", desc = "status" },
			{ "<leader>sq", "<cmd>lua require('fzf-lua').quickfix()<CR>", desc = "commits" },
			{ '<leader>ss"', "<cmd>lua require('fzf-lua').registers()<cr>", desc = "Registers" },
			{ "<leader>sa", "<cmd>lua require('fzf-lua').autocommands()<cr>", desc = "Auto Commands" },
			{ "<leader>sb", "<cmd>lua require('fzf-lua').current_buffer()<cr>", desc = "Buffer" },
			{ "<leader>sc", "<cmd>lua require('fzf-lua').command_history()<cr>", desc = "Command History" },
			{ "<leader>sC", "<cmd>lua require('fzf-lua').commands()<cr>", desc = "Commands" },
			{
				"<leader>sd",
				"<cmd>lua require('fzf-lua').diagnostics({ bufnr = 0 })<cr>",
				desc = "Document diagnostics",
			},
			{ "<leader>sD", "<cmd>lua require('fzf-lua').diagnostics()<cr>", desc = "Workspace diagnostics" },
			{ "<leader>sg", "<cmd>lua require('fzf-lua').grep({ search = '' })<cr>", desc = "Grep (root dir)" },
			{ "<leader>sG", "<cmd>lua require('fzf-lua').grep({ cwd = vim.fn.getcwd() })<cr>", desc = "Grep (cwd)" },
			{ "<leader>sh", "<cmd>lua require('fzf-lua').help_tags()<cr>", desc = "Help Pages" },
			{ "<leader>sH", "<cmd>lua require('fzf-lua').highlights()<cr>", desc = "Search Highlight Groups" },
			{ "<leader>sk", "<cmd>lua require('fzf-lua').keymaps()<cr>", desc = "Key Maps" },
			{ "<leader>sM", "<cmd>lua require('fzf-lua').man_pages()<cr>", desc = "Man Pages" },
			{ "<leader>sm", "<cmd>lua require('fzf-lua').marks()<cr>", desc = "Jump to Mark" },
			{ "<leader>so", "<cmd>lua require('fzf-lua').vim_options()<cr>", desc = "Options" },
			{ "<leader>sR", "<cmd>lua require('fzf-lua').resume()<cr>", desc = "Resume" },
			{ "gr", "<cmd>lua require('fzf-lua').lsp_references()<cr>", desc = "References" },
			{ "gi", "<cmd>lua require('fzf-lua').lsp_implementations()<cr>", desc = "Goto Implementation" },
			{ "gd", "<cmd>lua require('fzf-lua').lsp_definitions()<cr>", desc = "Goto Definition" },
			{ "gy", "<cmd>lua require('fzf-lua').lsp_typedefs()<cr>", desc = "Goto Type Definition" },
			{
				"<leader>sw",
				"<cmd>lua require('fzf-lua').grep_cword({ word_match = '-w' })<cr>",
				desc = "Word (root dir)",
			},
			{
				"<leader>sW",
				"<cmd>lua require('fzf-lua').grep_cword({ cwd = vim.fn.getcwd(), word_match = '-w' })<cr>",
				desc = "Word (cwd)",
			},
			{
				"<leader>sw",
				"<cmd>lua require('fzf-lua').grep_visual()<cr>",
				mode = "v",
				desc = "Selection (root dir)",
			},
			{
				"<leader>sW",
				"<cmd>lua require('fzf-lua').grep_visual({ cwd = vim.fn.getcwd() })<cr>",
				mode = "v",
				desc = "Selection (cwd)",
			},
			{
				"<leader>uC",
				"<cmd>lua require('fzf-lua').colorschemes({ preview = true })<cr>",
				desc = "Colorscheme with preview",
			},
			{
				"<leader>ss",
				function()
					require("fzf-lua").lsp_document_symbols({
						lsp_symbols = require("lazyvim.config").get_kind_filter(),
					})
				end,
				desc = "Goto Symbol",
			},
			{
				"<leader>sS",
				function()
					require("fzf-lua").lsp_workspace_symbols({
						lsp_symbols = require("lazyvim.config").get_kind_filter(),
					})
				end,
				desc = "Goto Symbol (Workspace)",
			},
		},
	},
	{
		-- Autocompletion
		"hrsh7th/nvim-cmp",
		dependencies = {
			-- Adds LSP completion capabilities
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-path",
			-- Adds a number of user-friendly snippets
			"rafamadriz/friendly-snippets",
		},
	},
	{
		"L3MON4D3/LuaSnip",
		dependencies = {
			"saadparwaiz1/cmp_luasnip",
		},
		event = "InsertEnter",
	},
	{
		"williamboman/mason.nvim",
		config = true,
		dependencies = {
			"williamboman/mason-lspconfig.nvim",
		},
		cmd = {
			"Mason",
		},
	},
	{ "folke/neodev.nvim", ft = "lua" },
	{ "neovim/nvim-lspconfig" },
	{ "VonHeikemen/lsp-zero.nvim", branch = "v3.x" },
	{ "echasnovski/mini.comment", config = true },
	{ "echasnovski/mini.surround", config = true },
	{ "echasnovski/mini.statusline", config = true },
	{ "folke/which-key.nvim", opts = {} },
	{
		"alexghergh/nvim-tmux-navigation",
		config = function()
			local nvim_tmux_nav = require("nvim-tmux-navigation")
			nvim_tmux_nav.setup({
				disable_when_zoomed = true,
			})
			vim.keymap.set("n", "<C-h>", nvim_tmux_nav.NvimTmuxNavigateLeft)
			vim.keymap.set("n", "<C-j>", nvim_tmux_nav.NvimTmuxNavigateDown)
			vim.keymap.set("n", "<C-k>", nvim_tmux_nav.NvimTmuxNavigateUp)
			vim.keymap.set("n", "<C-l>", nvim_tmux_nav.NvimTmuxNavigateRight)
			vim.keymap.set("n", "<C-\\>", nvim_tmux_nav.NvimTmuxNavigateLastActive)
			vim.keymap.set("n", "<C-Space>", nvim_tmux_nav.NvimTmuxNavigateNext)
		end,
	},
}
