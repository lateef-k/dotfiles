local function command(name, user_command, opts)
	local defaults = {
		bar = true,
        nargs = "?"
	}
	opts = vim.tbl_extend("force", defaults, opts or {})
	vim.api.nvim_create_user_command(name, user_command, opts)
end

-- Neovim dev
command("DebugLua", function()
	require("osv").run_this()
end)

command("ReloadModule", function(input)
	require("plenary.reload").reload_module(input.fargs[1])
	require(input.fargs[1])
end, { nargs = 1}) -- `bar=true` lets me chain commands afte with |

-- Open snippets for current filetype
command("LuasnipEditCurrent", function()
	require("luasnip.loaders").edit_snippet_files()
end)

-- Zk-nvim
command("CopyCurrentFileAsZkLink", function()
    vim.fn.setreg("@")
end)
