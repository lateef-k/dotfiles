local on_attach = require("mappings")["on_attach"]
local cmp_capabilities = require("config.nvim-cmp")

require('lspconfig')['sumneko_lua'].setup {
    on_attach = on_attach,
    capabilities = cmp_capabilities,
    settings = {
        Lua = {
            runtime = {
                -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                version = 'LuaJIT',
            },
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = { 'vim' },
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = vim.api.nvim_get_runtime_file("", true),
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = {
                enable = false,
            },
        },
    },
}


require('lspconfig')['pyright'].setup {
    on_attach = on_attach,
    capabilities = cmp_capabilities
}

require('lspconfig')['jsonls'].setup {
    on_attach = on_attach,
    capabilities = cmp_capabilities
}

require('lspconfig')['bashls'].setup {
    on_attach = on_attach,
    capabilities = cmp_capabilities
}
