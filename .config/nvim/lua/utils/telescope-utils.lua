-- map("n", "<leader>Z", ':Telescope grep_string shorten_path=true only_sort_text=true search=""<CR>', opts)

M = {}

M.fuzz_project_text = function()
	local builtin = require("telescope.builtin")
	local root = require("project_nvim.project").get_project_root()
	builtin.grep_string({
		shorten_path = true,
		only_sort_text = true,
		search = "",
		cwd = root or vim.fn.expand("%:p:h"),
	})
end

return M
