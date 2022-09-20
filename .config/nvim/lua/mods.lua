require("helper")

local mod_augroup = vim.api.nvim_create_augroup(
    "mod_augoup", { clear = true }
)

-- change working dir to match path of working file only if it exists
local cd_to_buffer = function()
    local buffer_index = vim.api.nvim_get_current_buf()
    local filename = vim.api.nvim_buf_get_name(buffer_index)
    if vim.fn.filereadable(filename) == 0 then
        return
    end
    vim.api.nvim_exec(":cd /" .. vim.fs.dirname(filename), false)
end

vim.api.nvim_create_autocmd({ "BufEnter", },
    {
        group = mod_augroup,
        callback = cd_to_buffer
    })
