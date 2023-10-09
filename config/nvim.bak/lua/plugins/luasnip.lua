local keymap = {
	store_selection_keys = "<M-v>",
}

return {
	"L3MON4D3/LuaSnip",
	event = "InsertEnter",
	config = function()
		require("luasnip").config.setup({
			store_selection_keys = keymap.store_selection_keys,
			history = true,
		})
		require("luasnip.loaders.from_snipmate").lazy_load() -- looks for snippets/ in rtp
		require("luasnip.loaders.from_lua").lazy_load()
		require("luasnip").filetype_extend("lua", { "luasnip", "luanvim" })
		require("luasnip").filetype_extend("telekasten", { "markdown" })
	end,
}
