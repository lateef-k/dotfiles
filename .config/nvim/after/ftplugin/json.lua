
require('lspconfig')['jsonls'].setup {
    on_attach = require("mappings").on_attach,
    capabilities = require("languages").capabilities,
}
