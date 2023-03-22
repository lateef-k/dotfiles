local function config()
    require("typescript").setup({
        disable_commands = false, -- prevent the plugin from creating Vim commands
        debug = false, -- enable debug logging for commands
        go_to_source_definition = {
            fallback = true, -- fall back to standard LSP definition on failure
        },
        server = { -- pass options to lspconfig's setup method
            on_attach = require("keymaps").on_attach_mappings,
            capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities()),
        },
    })
end

return {
    "jose-elias-alvarez/typescript.nvim",
    ft = "typescript",
    dependencies = { "hrsh7th/nvim-cmp" },
    config = config,
}
