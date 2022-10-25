Utils = {}

function Utils.split(str, delim)
    local res = {}
    for match in str:gmatch(string.format("[^%s]+", delim)) do
        table.insert(res, match);
    end
    return res
end

function Utils.ShowAttachedLsp()
    ---@diagnostic disable-next-line: param-type-mismatch
    print(vim.inspect(vim.lsp.get_active_clients()))
end

function Utils.today()
    local pos = vim.api.nvim_win_get_cursor(0)[2]
    local line = vim.api.nvim_get_current_line()
    local nline = line:sub(0, pos) .. vim.fn.strftime('%c') .. line:sub(pos + 1)
    vim.api.nvim_set_current_line("(" .. nline .. ")")
end

function Utils.find_files_in_root()
    local root = require("project_nvim.project").get_project_root()
    if root ~= nil then
        require("telescope.builtin").find_files {
            cwd = root
        }
    else
        print("No root found")
    end
end

function Utils.current_file_and_line()
    local filename = vim.api.nvim_buf_get_name(0) 
    local lineNo = unpack(vim.api.nvim_win_get_cursor(0))
    return filename .. ":" .. lineNo
end

return Utils
