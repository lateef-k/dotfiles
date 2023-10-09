return {
    "glepnir/lspsaga.nvim",
    lazy = true,
    config = function()
        require("lspsaga").setup({})
    end,
    dependencies = {
        { "nvim-tree/nvim-web-devicons" },
        --Please make sure you install markdown and markdown_inline parser
        { "nvim-treesitter/nvim-treesitter" },
    },
}
