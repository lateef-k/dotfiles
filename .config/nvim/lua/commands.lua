local command = vim.api.nvim_add_user_command

-- Dap ui
command("DapUiOpen", function()
	require("dapui").open()
end)
command("DapUiClose", function()
	require("dapui").close()
end)
command("DapUiToggle", function()
	require("dapui").toggle()
end)

-- Lua debugger

command("DebugLua", function()
	require("osv").run_this()
end)
