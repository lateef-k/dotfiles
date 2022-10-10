
require('lspconfig')['pyright'].setup {
    on_attach = require("mappings").on_attach,
    capabilities = require("config.nvim-cmp"),
}
