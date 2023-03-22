-- used for conjure, also:
-- https://www.reddit.com/r/vim/comments/bkfaff/localleader_what_are_you_guys_using_this_for/
local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Keymaps unrelated to plugins
----------------------------------------
-- use jj to exit insert mode, also avoid jumping cursor to left when exiting normal mode
map("i", "jk", "<esc>`^", opts)
map("i", "kj", "<esc>`^", opts)
map("i", "<esc>", "<nop>") -- get the jk and kj to stick
map("n", "]q", ":cn<CR>", opts)
map("n", "[q", ":cp<CR>", opts)
map("n", "<leader>q", require("utils.utils").toggle_qflist, opts)
map("n", "<leader><leader>q", "q", opts)
map("n", "<leader><leader>Q", "Q", opts)
-- so shift-tab works
map("i", "<S-Tab>", "<C-d>", opts)
map("n", "<esc>", ":noh<CR>", opts)
map("n", "]b", ":bn<CR>", opts)
map("n", "[b", ":bp<CR>", opts)
----------------------------------------
map("n", "<leader>ne", ":Neorg<CR>", opts)

map("t", "jk", [[<C-\><C-n>]], opts)
map("t", "kj", [[<C-\><C-n>]], opts)
map("t", "<C-h>", [[<Cmd>:TmuxNavigateLeft<CR>]], opts)
map("t", "<C-j>", [[<Cmd>:TmuxNavigateDown<CR>]], opts)
map("t", "<C-k>", [[<Cmd>:TmuxNavigateUp<CR>]], opts)
map("t", "<C-l>", [[<Cmd>:TmuxNavigateRight<CR>]], opts)

---
map("n", "<leader>du", ":lua require('dapui').toggle()<CR>", opts)
map("n", "<leader>db", ":lua require('dap').toggle_breakpoint()<CR>", opts)
map("n", "<leader>dc", ":lua require('dap').continue()<CR>", opts)
map("n", "<leader>dol", ":lua require('osv').launch({port=8086})<CR>", opts)

-- marks.nvim
-- mx              Set mark x
-- m,              Set the next available alphabetical (lowercase) mark
-- m;              Toggle the next available mark at the current line
-- dmx             Delete mark x
-- dm-             Delete all marks on the current line
-- dm<space>       Delete all marks in the current buffer
-- m]              Move to next mark
-- m[              Move to previous mark
-- m:              Preview mark. This will prompt you for a specific mark to
--                 preview; press <cr> to preview the next mark.
-- m[0-9]          Add a bookmark from bookmark group[0-9].
-- dm[0-9]         Delete all bookmarks from bookmark group[0-9].
-- m}              Move to the next bookmark having the same type as the bookmark under
--                 the cursor. Works across buffers.
-- m{              Move to the previous bookmark having the same type as the bookmark under
--                 the cursor. Works across buffers.
-- dm=             Delete the bookmark under the cursor.
--

-- sessions
map("n", "<leader>ss", "<cmd>SessionToggle<CR>", opts)
map("n", "<leader>sr", "<cmd>SessionRead<CR>", opts)
map("n", "<leader>sf", "<cmd>SessionSelect<CR>", opts)
map("n", "<leader>sd", "<cmd>SessionSelect delete<CR>", opts)

local function on_attach_lsp(_, bufnr)
	local bufopts = { noremap = true, silent = true, buffer = bufnr }
	local legendary = require("legendary")

	local keymaps = {
		{
			"]d",
			"<cmd>Lspsaga diagnostic_jump_next<CR>",
			description = "Jump to next diagnostic message of the current buffer",
			opts = bufopts,
		},
		{
			"[d",
			"<cmd>Lspsaga diagnostic_jump_prev<CR>",
			description = "Jump to previous diagnostic message of the current buffer",
			opts = bufopts,
		},
		{
			"<leader>lg",
			"<cmd>Lspsaga show_line_diagnostics<CR>",
			description = "Show diagnostic messages for the current line of the current buffer",
			opts = bufopts,
		},
		{
			"<leader>ld",
			":Telescope diagnostics bufnr=0<CR>",
			description = "List diagnostics messages for the current buffer",
			opts = bufopts,
		},
		{
			"<leader>lD",
			":Telescope diagnostics<CR>",
			description = "List diagnostic messages for all buffers",
			opts = bufopts,
		},
		{
			"]e",
			function()
				require("lspsaga.diagnostic"):goto_next({ severity = vim.diagnostic.severity.ERROR })
			end,
			opts = {noremap = true, silent = true},
		},
		{
			"[e",
			function()
				require("lspsaga.diagnostic"):goto_prev({ severity = vim.diagnostic.severity.ERROR })
			end,
			opts = {noremap = true, silent = true},
		},
		{
			"<leader>lp",
			"<cmd>Lspsaga peek_definition<CR>",
			description = "Preview definition of the symbol under the cursor",
			opts = bufopts,
		},
		{
			"<leader>lr",
			"<cmd>Lspsaga rename<CR>",
			description = "Rename symbol under the cursor",
			opts = bufopts,
		},
		{
			"<leader>la",
			"<cmd>Lspsaga code_action<CR>",
			description = "Show code actions for the symbol under the cursor",
			opts = bufopts,
		},
		{
			"<leader>lt",
			vim.lsp.buf.type_definition,
			description = "Jumps to the definition of the type of the symbol under the cursor",
			opts = bufopts,
		},
		{
			"<leader>lb",
			":lua vim.lsp.buf.format { async = true }<CR>",
			mode = { "n", "v" },
			description = "Format the current buffer or selected text",
			opts = bufopts,
		},
		{
			"<leader>ls",
			":Telescope lsp_document_symbols<CR>",
			description = "List symbols for the current buffer",
			opts = bufopts,
		},
		{
			"<leader>lS",
			":Telescope lsp_dynamic_workspace_symbols<CR>",
			description = "List symbols for the workspace",
			opts = bufopts,
		},
		{
			"<leader>l0",
			"<cmd>LSoutlineToggle<CR>",
			description = "Toggle LSP symbol outline",
			opts = bufopts,
		},
		{
			"<leader>lhi",
			":Telescope lsp_incoming_calls<CR>",
			description = "List incoming LSP calls",
			opts = bufopts,
		},
		{
			"<leader>lho",
			":Telescope lsp_outgoing_calls<CR>",
			description = "List outgoing LSP calls",
			opts = bufopts,
		},
		{
			"gl",
			"<cmd>Lspsaga lsp_finder<CR>",
			opts = bufopts,
		},
		{
			"gD",
			vim.lsp.buf.declaration,
			opts = bufopts,
		},
		{
			"K",
			"<cmd>Lspsaga hover_doc<CR>",
			description = "Show documentation for the symbol under the cursor",
			opts = bufopts,
		},
		{
			"gd",
			":Telescope lsp_definitions<CR>",
			description = "Jump to the definition of the symbol under the cursor.",
			opts = bufopts,
		},
		{
			"gr",
			":Telescope lsp_references<CR>",
			description = "List all references to the symbol under the cursor.",
			opts = bufopts,
		},
		{
			"L",
			vim.lsp.buf.signature_help,
			description = "Display signature help for the symbol under the cursor.",
			opts = bufopts,
		},
		{
			"<leader>gi",
			vim.lsp.buf.implementation,
			description = "Jump to the implementation of the symbol under the cursor.",
			opts = bufopts,
		},
		{
			"<leader>lwa",
			vim.lsp.buf.add_workspace_folder,
			description = "Add the current folder to the workspace folders of the current LSP client.",
			opts = bufopts,
		},
		{
			"<leader>lwr",
			vim.lsp.buf.remove_workspace_folder,
			description = "Remove the current folder from the workspace folders of the current LSP client.",
			opts = bufopts,
		},
		{
			"<leader>lwl",
			function()
				print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
			end,
			description = "List all workspace folders of the current LSP client.",
			opts = bufopts,
		},
	}
	legendary.itemgroup({
		itemgroup = "LSP keymaps",
		keymaps = keymaps,
	})
end

local toggleterm = {
	open_mapping = "<C-F>",
}
-- to avoid evaluating requires right away
local function telescope_lazy()
	return {
		default = {
			mappings = {
				-- this + send to quickfix is really useful, using fzf's filtering capabilities
				n = {
					["<C-g>"] = require("telescope.actions").select_all,
				},
				i = {
					["<C-g>"] = require("telescope.actions").select_all,
				},
			},
		},
		pickers = {
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
	}
end

local mini = {
	ai = {
		goto_left = "[g",
		goto_right = "]g",
	},
}

return {
	on_attach_mappings = on_attach_lsp,
	telescope_lazy = telescope_lazy,
	mini = mini,
	toggleterm = toggleterm,
}
