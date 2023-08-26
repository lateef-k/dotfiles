local function config()
    require("null-ls").setup({
        sources = {
            require("null-ls").builtins.formatting.black,
            require("null-ls").builtins.formatting.isort,
            require("null-ls").builtins.formatting.stylua,
            require("null-ls").builtins.formatting.rome,
            require("null-ls").builtins.formatting.prettier,
        },
        on_attach = require("keymaps").on_attach_mappings,
    })
end

return {
    "jose-elias-alvarez/null-ls.nvim",
    lazy = true,
    config = config,
}
