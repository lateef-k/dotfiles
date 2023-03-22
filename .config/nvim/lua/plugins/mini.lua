return {
	"echasnovski/mini.nvim",
    event = "UIEnter",
	config = function()
		local spec_treesitter = require("mini.ai").gen_spec.treesitter
		require("mini.ai").setup({
			n_lines = 10000,
			mappings = require("keymaps").mini.ai,
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
}
