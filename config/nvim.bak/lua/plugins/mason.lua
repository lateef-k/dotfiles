return {
	"williamboman/mason.nvim",
	dependencies = {
		{ "williamboman/mason-lspconfig.nvim", config = true },
	},
	ft = {
		"lua",
		"python",
		"sh",
		"json",
		"c",
		"css",
		"astro",
		"go",
		"html",
		"markdown",
		"svelte",
		"typescript",
	},
	cmd = {
		"Mason",
		"MasonInstall",
		"MasonUninstall",
		"MasonUninstallAll",
		"MasonLog",
	},
	config = true,
}
