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
return Helper
