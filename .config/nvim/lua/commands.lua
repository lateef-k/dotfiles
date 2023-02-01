local function command(name, user_command, opts)
	local defaults = {
		bar = true,
		nargs = "?",
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
end, { nargs = 1 }) -- `bar=true` lets me chain commands afte with |

-- Open snippets for current filetype
command("LuasnipEditCurrent", function()
	require("luasnip.loaders").edit_snippet_files()
end)

-- Sessions
local sessions = require("mini.sessions")
command("SessionStart", function()
	local path = vim.fn.getcwd()
	path = vim.fn.fnameescape(path)
	path = path:gsub("/", "%%")
	sessions.write(path)
end)

command("SessionStop", function()
	vim.v.this_session = ""
end)

command("SessionToggle", function()
	if vim.v.this_session == "" then
		vim.cmd([[SessionStart]])
	else
		vim.cmd([[ SessionStop ]])
	end
end)

command("SessionRead", function()
	local path = vim.fn.getcwd()
	path = vim.fn.fnameescape(path)
	path = path:gsub("/", "%%")

	local existing_sessions = vim.tbl_keys(sessions.detected)
	if not vim.tbl_contains(existing_sessions, path) then
		vim.notify("No session for CWD exists", vim.log.levels.INFO)
	else
		sessions.read(path)
	end
end)

command("SessionSelect", function(inp)
	if inp.args == "" then
		sessions.select()
	else
		sessions.select(inp.args)
	end
end)
--
