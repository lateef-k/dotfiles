local function attach_keymaps(bufnr)
	local bufopts = {
		noremap = true,
		silent = true,
		buffer = bufnr,
	}
	local keymaps = {
		{
			"<leader>grh",
			":Gitsigns reset_hunk<CR>",
			description = "Resets the current hunk",
			mode = { "n", "v" },
			opts = bufopts,
		},
		{
			"<leader>gsb",
			require("gitsigns").stage_buffer,
			mode = { "i" },
			description = "Stages the current buffer",
			opts = bufopts,
		},
		{
			"<leader>gD",
			function()
				require("gitsigns").diffthis("~")
			end,
			description = "diff the current file",
			opts = bufopts,
		}, -- notice if the first element is "n", we don't need to explicitly include the mode.
		{
			"]c",
			function()
				if vim.wo.diff then
					return "]c"
				end
				vim.schedule(function()
					require("gitsigns").next_hunk()
				end)
				return "<Ignore>"
			end,
			description = "Jump to next git hunk",
			opts = { unpack(bufopts), expr = true },
		},
		{
			"[c",
			function()
				if vim.wo.diff then
					return "[c"
				end
				vim.schedule(function()
					require("gitsigns").prev_hunk()
				end)
				return "<Ignore>"
			end,
			description = "Jump to previous git hunk",
			opts = { unpack(bufopts), expr = true },
		},
		{
			"<leader>gsh",
			":Gitsigns stage_hunk<CR>",
			description = "Stages the current hunk",
			mode = { "n", "v" },
			opts = bufopts,
		},
		{
			"<leader>grh",
			":Gitsigns reset_hunk<CR>",
			description = "Resets the current hunk",
			mode = { "n", "v" },
			opts = bufopts,
		},
		{
			"<leader>gsb",
			require("gitsigns").stage_buffer,
			description = "Stages the current buffer",
			opts = bufopts,
		},
		{
			"<leader>grb",
			require("gitsigns").reset_buffer,
			description = "Resets the current buffer",
			opts = bufopts,
		},
		{
			"<leader>guh",
			require("gitsigns").undo_stage_hunk,
			description = "Undo staging the current hunk",
			opts = bufopts,
		},
		{
			"<leader>gph",
			require("gitsigns").preview_hunk,
			description = "Preview the changes of the current hunk",
			opts = bufopts,
		},
		{
			"<leader>gbb",
			function()
				require("gitsigns").blame_line({ full = true })
			end,
			description = "Blame the current line",
			opts = bufopts,
		},
		{
			"<leader>gbl",
			require("gitsigns").toggle_current_line_blame,
			description = "Toggle blame for the current line",
			opts = bufopts,
		},
		{
			"<leader>gd",
			require("gitsigns").diffthis,
			description = "Diff the current changes",
			opts = bufopts,
		},
		{
			"<leader>gD",
			function()
				require("gitsigns").diffthis("~")
			end,
			description = "Diff the current file",
			opts = bufopts,
		},
		{
			"<leader>gtd",
			require("gitsigns").toggle_deleted,
			description = "Toggle diffing of deleted text",
			opts = bufopts,
		},
		{
			"ih",
			":<C-U>Gitsigns select_hunk<CR>",
			description = "Select the current hunk as text object",
			mode = { "o", "x" },
			opts = bufopts,
		},
	}
	require("legendary").itemgroup({
		itemgroup = "gitsigns.nvim",
		keymaps = keymaps,
	})
end

return {
	"lewis6991/gitsigns.nvim",
    event = "BufReadPost",
	opts = {
		on_attach = attach_keymaps,
	},
}
