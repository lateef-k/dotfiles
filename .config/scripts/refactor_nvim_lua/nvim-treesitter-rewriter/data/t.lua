

local a = {1,2, a = 5}
print(#a)


local parsers = require("nvim-treesitter.parsers")

local bufnr = vim.api.nvim_get_current_buf()
local parser = parsers.get_parser(bufnr)
print(vim.inspect(parser))
