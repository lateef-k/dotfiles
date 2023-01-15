

local buffer = require("nvim-treesitter-rewriter.buffer")

local M = {}

function M.start()
    buffer.open_input_buffer()
end

return M
