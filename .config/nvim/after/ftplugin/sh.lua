

require('lspconfig')['bashls'].setup {
    on_attach = require("mappings").on_attach,
    capabilities = require("languages").capabilities,
}
