-- used for conjure, also:
-- https://www.reddit.com/r/vim/comments/bkfaff/localleader_what_are_you_guys_using_this_for/
local map = vim.keymap.set
vim.g.mapleader = " "
vim.g.localmapleader = "\\"
local opts = { noremap = true, silent = true }

-- Keymaps unrelated to plugins
----------------------------------------
-- use jj to exit insert mode, also avoid jumping cursor to left when exiting normal mode 
map("i", "jk", "<esc>`^", opts)
map("i", "kj", "<esc>`^", opts)
map("i", "<esc>", "<nop>") -- get the jk and kj to stick
map("n", "]b", ":bn<CR>", opts)
map("n", "[b", ":bp<CR>", opts)
map("n", "]q", ":cn<CR>", opts)
map("n", "[q", ":cp<CR>", opts)
map("n", "*",":keepjump !norm *")

-- so shift-tab works
map("i", "<S-Tab>", "<C-d>", opts)
map("n", "<esc>", ":noh<CR>", opts)
----------------------------------------
--
-- to avoid evaluating requires right away
local telescope_lazy = function()
	return {
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
	}
end

local nvim_treesitter = {
	incremental_selection = {
		keymaps = {
			init_selection = "]ni",
			scope_incremental = "]ns",
			node_incremental = "]nn",
			node_decremental = "[nn",
		},
	},
}

local cmp = {
	mapping = require("cmp").mapping.preset.insert({
		["<Tab>"] = require("cmp").mapping(function(fallback)
			if require("cmp").visible() then
				require("cmp").select_next_item()
			else
				fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
			end
		end, { "n", "i", "s" }),
		["<S-Tab>"] = require("cmp").mapping(function(fallback)
			if require("cmp").visible() then
				require("cmp").select_prev_item()
			else
				fallback()
			end
		end, { "i", "s" }),
		-- gh to r-enter select mode and continue selecting
		["<M-j>"] = require("cmp").mapping(function(fallback)
			if require("luasnip").expand_or_jumpable() then
				return require("luasnip").expand_or_jump()
			else
				fallback()
			end
		end, { "n", "i", "s" }),

		["<M-k>"] = require("cmp").mapping(function(fallback)
			if require("luasnip").jumpable(-1) then
				return require("luasnip").jump(-1)
			else
				fallback()
			end
		end, { "n", "i", "s" }),

		["<M-l>"] = require("cmp").mapping(function(fallback)
			if require("luasnip").choice_active() then
				return require("luasnip").change_choice(1)
			else
				fallback()
			end
		end, { "n", "i", "s" }),
		["<M-h>"] = require("cmp").mapping(function(fallback)
			if require("luasnip").choice_active() then
				return require("luasnip").change_choice(-1)
			else
				fallback()
			end
		end, { "n", "i", "s" }),
		["<C-Space>"] = require("cmp").mapping.complete(),
		["<C-x>"] = require("cmp").mapping.abort(),
		["<CR>"] = require("cmp").mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
	}),
}

local luasnip = {
	store_selection_keys = "<M-v>",
}

local neorg_mapping = {
	{ "n", "<localleader>ts", ":Neorg toc split<CR>" },
}

map("n", "<leader>ne", ":Neorg<CR>", opts)

map("n", "<leader>q", "q", opts)
map("n", "<leader>Q", "Q", opts)
-- never talk to me or my s key ever again
map({ "n", "x", "o" }, "q", "<Plug>(leap-forward-to)", opts) --inclusive
map({ "n", "x", "o" }, "Q", "<Plug>(leap-backward-to)", opts)
map({ "x", "o" }, "x", "<Plug>(leap-forward-till)", opts) --exclusive
map({ "x", "o" }, "X", "<Plug>(leap-backward-till)", opts)
map({ "n", "x", "o" }, "<C-q>", "<Plug>(leap-cross-window)", opts)

-- telescope
-- if i change lua functions to vim string, can make telescope lazily loaded
-- telecsope menu
map("n", "<leader>ft", ":Telescope<CR>", opts)
-- files
map("n", "<leader>fj", ":Telescope projects<CR>", opts)
map("n", "<leader>fp", require("utils").find_files_in_root, opts)
map("n", "<leader>ff", ":Telescope find_files<CR>", opts)
map("n", "<leader>fb", ":Neotree position=left toggle=true action=focus<CR>", opts)
map("n", "<leader>fo", ":Telescope oldfiles<CR>", opts)
map("n", "<leader>fg", ":Telescope git_files<CR>", opts)
-- text search
-- get all text and use fuzzy as a sorter
map("n", "<leader>fz", ':Telescope grep_string shorten_path=true only_sort_text=true search=""<CR>', opts)

-- AFAIK, both :Rg and :Ag do pretty much what grep_string does, they search for something and feed the matches (or feed the entire lines of the project when used with no search string) to Telescope to be fuzzy searched.
-- live_grep is a different story, each keystroke generates a new rg (or ag) command and the results are returned to Telescope, there's no fuzzy search here but rather a regex search of the typed query.
local on_attach_mappings = function(_, bufnr)
	local bufopts = { noremap = true, silent = true, buffer = true }
	map("n", "]d", "<cmd>Lspsaga diagnostic_jump_next<CR>", bufopts)
	map("n", "[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>", bufopts)
	map("n", "gl", "<cmd>Lspsaga lsp_finder<CR>", bufopts)
	map("n", "<leader>lp", "<cmd>Lspsaga peek_definition<CR>", bufopts)
	map("n", "<leader>lr", "<cmd>Lspsaga rename<CR>", bufopts)
	map("n", "<leader>la", "<cmd>Lspsaga code_action<CR>", bufopts)
	map("n", "<leader>lt", vim.lsp.buf.type_definition, bufopts)
	map("n", "<leader>lb", ":lua vim.lsp.buf.format { async = true }<CR>", bufopts)
	map("n", "<leader>ls", ":Telescope lsp_document_symbols<CR>", bufopts)
	map("n", "<leader>lS", ":Telescope lsp_dynamic_workspace_symbols<CR>", bufopts)
	map("n", "<leader>lg", "<cmd>Lspsaga show_line_diagnostics<CR>", bufopts)
	map("n", "<leader>ld", ":Telescope diagnostics bufnr=0<CR>", bufopts)
	map("n", "<leader>lD", ":Telescope diagnostics<CR>", bufopts)
	map("n", "<leader>l0", "<cmd>LSoutlineToggle<CR>", bufopts)
	--- these are leaderless to be consistent with defaults and vim built ins
	map("n", "gD", vim.lsp.buf.declaration, bufopts)
	map("n", "K", "<cmd>Lspsaga hover_doc<CR>", bufopts)
	map("n", "gd", ":Telescope lsp_definitions<CR>", bufopts)
	map("n", "gr", ":Telescope lsp_references<CR>", bufopts)
	map("n", "L", vim.lsp.buf.signature_help, bufopts) -- useful while typing
	map("n", "<leader>gi", vim.lsp.buf.implementation, bufopts)
	map("n", "<leader>lwa", vim.lsp.buf.add_workspace_folder, bufopts)
	map("n", "<leader>lwr", vim.lsp.buf.remove_workspace_folder, bufopts)
	map("n", "<leader>lwl", function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, bufopts)
end

-- special 1 key command
map("n", "<leader>b", ":Telescope buffers<CR>", opts)
map("n", "<leader>z", ":Telescope current_buffer_fuzzy_find<CR>", opts)
map("n", "<leader>r", ":Telescope resume<CR>", opts)

return {
	on_attach_mappings = on_attach_mappings,
	telescope_lazy = telescope_lazy,
	nvim_treesitter = nvim_treesitter,
	cmp = cmp,
	neorg_mapping = neorg_mapping,
	luasnip = luasnip,
}
