local function command(name, user_command, opts)
	local defaults = {
		bar = true,
	}
    opts = vim.tbl_extend("force", defaults, opts or {})
    vim.api.nvim_create_user_command(name, user_command, opts)
end

command("TSRewrite", function()
    require("nvim-treesitter-rewriter.core").start()
end)


