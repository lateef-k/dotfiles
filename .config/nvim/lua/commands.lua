local function command(name, user_command, opts)
    local defaults = {
        bar = true,
        nargs = "?",
    }
    opts = vim.tbl_extend("force", defaults, opts or {})
    vim.api.nvim_create_user_command(name, user_command, opts)
end

-- Neovim dev

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

command("TmuxPickRestore", function()
    require("utils.telescope-utils").choose_restore_tmux()
end)

--
-- local PastDirectory
-- command("SwitchDirectory", function()
--     local root = require("project_nvim.project").get_project_root()
--     local new_cwd = root or vim.fn.expand("%:p:h")
--     vim.cmd("silent! lcd " .. new_cwd)
-- end)
-- opts = {},
-- description = "Change directory to current file's parent",
