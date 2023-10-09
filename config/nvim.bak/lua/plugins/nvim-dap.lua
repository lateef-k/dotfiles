local function on_attach()
    local opts = { noremap = true, silent = true }
    local keymaps = {
        {
            "<leader>du",
            ":lua require('dapui').toggle()<CR>",
            description = "Toggle DAP UI",
            opts = opts,
        },

        {
            "<leader>db",
            ":lua require('dap').toggle_breakpoint()<CR>",
            description = "Toggle breakpoint",
            opts = opts,
        },

        {
            "<leader>dc",
            ":lua require('dap').continue()<CR>",
            description = "Continue execution",
            opts = opts,
        },

        {
            "<leader>dol",
            ":lua require('osv').launch({port=8086})<CR>",
            description = "Launch OSV debugger",
            opts = opts,
        },
    }

    local commands = {
        {
            "DebugLua",
            function()
                require("osv").run_this()
            end,
            description = "Start lua debugging",
        },
    }
    require("legendary").itemgroup({
        itemgroup = "nvim-dap",
        keymaps = keymaps,
        commands = commands,
    })
end

return {
    "mfussenegger/nvim-dap",
    keys = { "<leader>d" },
    dependencies = {
        {
            "rcarriga/nvim-dap-ui",
            config = true,
        },
        { "jbyuki/one-small-step-for-vimkind" },
    },
    config = function()
        on_attach()
        local dap = require("dap")

        dap.configurations.lua = {
            {
                type = "nlua",
                request = "attach",
                name = "Attach to running Neovim instance",
            },
        }

        dap.adapters.nlua = function(callback, config)
            callback({ type = "server", host = config.host or "127.0.0.1", port = config.port or 8086 })
        end
    end,
}
