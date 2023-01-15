require("neodev").setup({})
require("lspconfig")["sumneko_lua"].setup({
	on_attach = require("mappings").on_attach_mappings,
	capabilities = require("config.nvim-cmp"),
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
                checkThirdParty = false
			},
			-- Do not send telemetry data containing a randomized but unique identifier
			telemetry = {
				enable = false,
			},
		},
	},
})

require("lspconfig")["pyright"].setup({
	on_attach = require("mappings").on_attach_mappings,
	capabilities = require("config.nvim-cmp"),
	settings = {
		python = {
			analysis = {
				typeCheckingMode = "basic",
			},
		},
	},
})

require("lspconfig")["bashls"].setup({
	on_attach = require("mappings").on_attach_mappings,
	capabilities = require("config.nvim-cmp"),
})

require("lspconfig")["jsonls"].setup({
	on_attach = require("mappings").on_attach_mappings,
	capabilities = require("config.nvim-cmp"),
})

require("lspconfig")["clangd"].setup({
	on_attach = require("mappings").on_attach_mappings,
	capabilities = require("config.nvim-cmp"),
})

require("lspconfig")["astro"].setup({
	on_attach = require("mappings").on_attach_mappings,
	capabilities = require("config.nvim-cmp"),
})
require("lspconfig")["tailwindcss"].setup({
	on_attach = require("mappings").on_attach_mappings,
	capabilities = require("config.nvim-cmp"),
})
require("lspconfig")["gopls"].setup({
	on_attach = require("mappings").on_attach_mappings,
	capabilities = require("config.nvim-cmp"),
})
