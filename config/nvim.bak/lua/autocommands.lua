require("legendary").autocmd({
    name = "main autocmds",
    clear = true,
    {
        "BufEnter",
        vim.cmd('if isdirectory(expand("%")) | Neotree'),
        opts = {
            once = true,
        },
        description = "Open Neotree if nvim is opened on a directory",
    },
    {
        "BufNew",
        function()
            if (vim.bo.buftype == "nofile") then
                vim.cmd([[
             setlocal foldlevel=4
            ]])
            end
        end,
        opts = {},
        description = "Set foldlevel to 3 on BufReadPost or FileReadPost for markdown files",
    },
})
