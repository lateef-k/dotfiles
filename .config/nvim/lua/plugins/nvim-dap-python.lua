return {
    "mfussenegger/nvim-dap-python",
    ft = "python",
    config = function()
        local path = require("consts").external_deps
        require("dap-python").setup(path .. "/debugpy/bin/python")
    end,
}
