return {
	"rebelot/kanagawa.nvim",
	config = function()
		require("kanagawa").setup({
			dimInactive = false, -- dim inactive window `:h hl-NormalNC`
		})
		vim.cmd("colorscheme kanagawa")
	end,
}
