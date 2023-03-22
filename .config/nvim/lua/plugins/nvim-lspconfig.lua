local function config()
    require("neodev").setup({})

    -- trigger thier configs
    require("null-ls")
    require("lspsaga")

    local nvim_cmp_capabilities =
        require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

    require("lspconfig")["lua_ls"].setup({
        on_attach = require("keymaps").on_attach_mappings,
        capabilities = nvim_cmp_capabilities,
        settings = {
            Lua = {
                runtime = {
                    -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                    version = "LuaJIT",
                },
                diagnostics = {
                    -- Get the language server to recognize the `vim` global
                    disable = { "missing-parameter" },
                },
                workspace = {
                    -- Make the server aware of Neovim runtime files
                    -- NOTE: neodev will do this instead
                    -- library = vim.api.nvim_get_runtime_file("", true),
                    checkThirdParty = false,
                },
                -- Do not send telemetry data containing a randomized but unique identifier
                telemetry = {
                    enable = false,
                },
            },
        },
    })

    require("lspconfig")["pyright"].setup({
        on_attach = require("keymaps").on_attach_mappings,
        capabilities = nvim_cmp_capabilities,
        settings = {
            python = {
                analysis = {
                    typeCheckingMode = "basic",
                },
            },
        },
    })
    require("lspconfig")["bashls"].setup({
        on_attach = require("keymaps").on_attach_mappings,
        capabilities = nvim_cmp_capabilities,
    })
    require("lspconfig")["jsonls"].setup({
        on_attach = require("keymaps").on_attach_mappings,
        capabilities = nvim_cmp_capabilities,
    })
    require("lspconfig")["clangd"].setup({
        on_attach = require("keymaps").on_attach_mappings,
        capabilities = nvim_cmp_capabilities,
    })
    require("lspconfig")["astro"].setup({
        on_attach = require("keymaps").on_attach_mappings,
        capabilities = nvim_cmp_capabilities,
    })
    require("lspconfig")["tailwindcss"].setup({
        on_attach = require("keymaps").on_attach_mappings,
        capabilities = nvim_cmp_capabilities,
    })
    require("lspconfig")["gopls"].setup({
        on_attach = require("keymaps").on_attach_mappings,
        capabilities = nvim_cmp_capabilities,
    })
    require("lspconfig")["marksman"].setup({
        on_attach = require("keymaps").on_attach_mappings,
        capabilities = nvim_cmp_capabilities,
    })
    require("lspconfig")["ruff_lsp"].setup({
        on_attach = require("keymaps").on_attach_mappings,
        capabilities = nvim_cmp_capabilities,
    })
    require("lspconfig")["svelte"].setup({
        on_attach = require("keymaps").on_attach_mappings,
        capabilities = nvim_cmp_capabilities,
    })
end

return {
    "neovim/nvim-lspconfig",
    dependencies = {
        { "hrsh7th/nvim-cmp" },
    },
    ft = {

        "python",
        "sh",
        "bash",
        "json",
        "c",
        "astro",
        "html",
        "go",
        "css",
        "lua",
        "svelte",
        "javascript",
        "typescript"
    },
    config = config,
}
