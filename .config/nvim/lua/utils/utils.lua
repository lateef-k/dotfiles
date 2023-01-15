Utils = {}

function Utils.split(str, delim)
	local res = {}
	for match in str:gmatch(string.format("[^%s]+", delim)) do
		table.insert(res, match)
	end
	return res
end

function Utils.find_files_in_root()
	local root = require("project_nvim.project").get_project_root()
	if root ~= nil then
		require("telescope.builtin").find_files({
			cwd = root,
		})
	else
		print("No root found")
	end
end

function Utils.toggle_qflist()
	local win_status = (vim.fn.getqflist({ winid = 1 }))
	if win_status.winid == 0 then
		vim.cmd("copen")
	else
		vim.cmd("cclose")
	end
end

return Utils
