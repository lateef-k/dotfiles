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

-- never talk to me or my s key ever again
map({ "n", "x", "o" }, "q", "<Plug>(leap-forward-to)", opts) --inclusive
map({ "n", "x", "o" }, "Q", "<Plug>(leap-backward-to)", opts)
map({ "x", "o" }, "x", "<Plug>(leap-forward-till)", opts) --exclusive
map({ "x", "o" }, "X", "<Plug>(leap-backward-till)", opts)
map({ "n", "x", "o" }, "<C-q>", "<Plug>(leap-cross-window)", opts)

-- telescope
-- if i change lua functions to vim string, can make telescope lazily loaded
-- telecsope menu
map("n", "<leader>tt", ":Telescope<CR>", opts)
-- files
map("n", "<leader>fj", ":Telescope projects<CR>", opts)
map("n", "<leader>fp", require("utils.utils").find_files_in_root, opts)
map("n", "<leader>ff", ":Telescope find_files<CR>", opts)
map("n", "<leader>fb", ":Neotree position=left toggle=true action=focus<CR>", opts)
map("n", "<leader>fo", ":Telescope oldfiles<CR>", opts)
map("n", "<leader>fg", ":Telescope git_files<CR>", opts)
-- text search
-- get all text and use fuzzy as a sorter
map("n", "<leader>Z", ':Telescope grep_string shorten_path=true only_sort_text=true search=""<CR>', opts)

-- AFAIK, both :Rg and :Ag do pretty much what grep_string does, they search for something and feed the matches (or feed the entire lines of the project when used with no search string) to Telescope to be fuzzy searched.
-- live_grep is a different story, each keystroke generates a new rg (or ag) command and the results are returned to Telescope, there's no fuzzy search here but rather a regex search of the typed query.

-- special 1 key command
map("n", "<leader>b", ":Telescope buffers<CR>", opts)
map("n", "<leader>z", ":Telescope current_buffer_fuzzy_find<CR>", opts)
map("n", "<leader>r", ":Telescope resume<CR>", opts)

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

map("n", "<leader>na", "<cmd>ZAll<CR>", opts)
map("n", "<leader>nn", "<cmd>ZNotes<CR>", opts)
map("n", "<leader>nj", "<cmd>ZJournal<CR>", opts)
map("n", "<leader>nej", "<cmd>ZJournalNew<CR>", opts)
map("n", "<leader>nen", "<cmd>ZkNew<CR>", opts)
map({ "n", "v" }, "<leader>nvt", "<cmd>ZkNewFromTitleSelection<CR>", opts)
map({ "n", "v" }, "<leader>nvc", "<cmd>ZkNewFromContentSelection<CR>", opts)

local function on_attach_mappings(_, bufnr)
	local bufopts = { noremap = true, silent = true, buffer = bufnr }
	map("n", "]d", "<cmd>Lspsaga diagnostic_jump_next<CR>", bufopts)
	map("n", "[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>", bufopts)
	map("n", "<leader>lg", "<cmd>Lspsaga show_line_diagnostics<CR>", bufopts)
	map("n", "<leader>ld", ":Telescope diagnostics bufnr=0<CR>", bufopts)
	map("n", "<leader>lD", ":Telescope diagnostics<CR>", bufopts)
	map("n", "]e", function()
		require("lspsaga.diagnostic").goto_next({ severity = vim.diagnostic.severity.ERROR })
	end, { silent = true })
	map("n", "[e", function()
		require("lspsaga.diagnostic").goto_prev({ severity = vim.diagnostic.severity.ERROR })
	end, { silent = true })

	map("n", "<leader>lp", "<cmd>Lspsaga peek_definition<CR>", bufopts)
	map("n", "<leader>lr", "<cmd>Lspsaga rename<CR>", bufopts)
	map("n", "<leader>la", "<cmd>Lspsaga code_action<CR>", bufopts)
	map("n", "<leader>lt", vim.lsp.buf.type_definition, bufopts)
	map({ "n", "v" }, "<leader>lb", ":lua vim.lsp.buf.format { async = true }<CR>", bufopts)
	map("n", "<leader>ls", ":Telescope lsp_document_symbols<CR>", bufopts)
	map("n", "<leader>lS", ":Telescope lsp_dynamic_workspace_symbols<CR>", bufopts)
	map("n", "<leader>l0", "<cmd>LSoutlineToggle<CR>", bufopts)
	map("n", "<leader>lhi", ":Telescope lsp_incoming_calls<CR>", bufopts)
	map("n", "<leader>lho", ":Telescope lsp_outgoing_calls<CR>", bufopts)
	--- these are leaderless to be consistent with defaults and vim built ins
	map("n", "gl", "<cmd>Lspsaga lsp_finder<CR>", bufopts)
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

local function on_attach_gitsigns(bufnr)
	local gs = package.loaded.gitsigns

	local bufopts = {
		unpack(opts),
		buffer = bufnr,
	}
	-- Navigation
	map("n", "]c", function()
		if vim.wo.diff then
			return "]c"
		end
		vim.schedule(function()
			gs.next_hunk()
		end)
		return "<Ignore>"
	end, { unpack(bufopts), expr = true })

	map("n", "[c", function()
		if vim.wo.diff then
			return "[c"
		end
		vim.schedule(function()
			gs.prev_hunk()
		end)
		return "<Ignore>"
	end, { unpack(bufopts), expr = true })

	-- Actions
	map({ "n", "v" }, "<leader>gsh", ":Gitsigns stage_hunk<CR>", bufopts)
	map({ "n", "v" }, "<leader>grh", ":Gitsigns reset_hunk<CR>", bufopts)
	map("n", "<leader>gsb", gs.stage_buffer, bufopts)
	map("n", "<leader>grb", gs.reset_buffer, bufopts)
	map("n", "<leader>guh", gs.undo_stage_hunk, bufopts)
	map("n", "<leader>gph", gs.preview_hunk, bufopts)
	map("n", "<leader>gbb", function()
		gs.blame_line({ full = true })
	end, bufopts)
	map("n", "<leader>gbl", gs.toggle_current_line_blame, bufopts)
	map("n", "<leader>gd", gs.diffthis, bufopts)
	map("n", "<leader>gD", function()
		gs.diffthis("~")
	end, bufopts)
	map("n", "<leader>gtd", gs.toggle_deleted, bufopts)

	-- Text object
	map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", bufopts)
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

local function cmp()
	return {
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
end

local luasnip = {
	store_selection_keys = "<M-v>",
}

local mini = {
	ai = {
		goto_left = "[g",
		goto_right = "]g",
	},
}

return {
	on_attach_mappings = on_attach_mappings,
	telescope_lazy = telescope_lazy,
	nvim_treesitter = nvim_treesitter,
	cmp = cmp,
	neorg_mapping = neorg_mapping,
	luasnip = luasnip,
	mini = mini,
	on_attach_gitsigns = on_attach_gitsigns,
	toggleterm = toggleterm,
}
