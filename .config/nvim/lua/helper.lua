Helper = {}

function Helper.split(str, delim)
    local res = {}
    for match in str:gmatch(string.format("[^%s]+", delim)) do
        table.insert(res, match);
    end
    return res
end

function Helper.ShowAttachedLsp()
    ---@diagnostic disable-next-line: param-type-mismatch
    print(vim.inspect(vim.lsp.get_active_clients()))
end

function Helper.today()
  local pos = vim.api.nvim_win_get_cursor(0)[2]
  local line = vim.api.nvim_get_current_line()
  local nline = line:sub(0, pos) .. vim.fn.strftime('%c')  .. line:sub(pos + 1)
  vim.api.nvim_set_current_line(nline)
end

return Helper
