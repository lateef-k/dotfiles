-- Bootstrap
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.g.localmapleader = "\\"

require("lazy").setup("plugins", {
    performance = {
        cache = {
            enabled = true
        }
    }
})
require("keymaps")
require("autocommands")
require("commands")

vim.opt.relativenumber = true
-- vim.opt if for things you would set in vimscript. vim.g is for things you'd let.

vim.opt.tabstop = 4 -- tabs should equal 4 characters
vim.opt.shiftwidth = 4 -- >> will shift by 4 characters
vim.opt.expandtab = true -- use space char for tabbing
vim.opt.smarttab = true
vim.opt.wrap = true -- soft tab
vim.opt.scrolloff = 999 -- keep cursor in center
vim.opt.clipboard:append({ "unnamedplus" }) -- use system clipboard
vim.opt.switchbuf:append({ "usetab", "newtab" }) -- NOTE THIS AFFECTS QUICKFIX BEHAVIOR
vim.opt.shortmess:append("I") --disable intro
vim.opt.completeopt = "menu,menuone,noselect,noinsert"
vim.opt.timeoutlen = 500
vim.opt.termguicolors = true -- for feline

vim.opt.termbidi = true
vim.opt.cursorline = true

vim.opt.undofile = true
vim.opt.undodir = vim.fn.expand("~/.cache/nvim/undodir")
vim.opt.splitright = true -- vertical splits prefer right

-- lower and uppercase search, unless uppercase
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- security risk
vim.opt.modeline = false

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- running `:StartupTime -- file.py` and then `checkhealth` showed the culprit of slow loading time to be the component which is loading the python provider
-- not sure if this showed up recently or something happened

-- vim.opt.foldmethod = "expr"
-- vim.opt.foldexpr = "nvim_treesitter#foldexpr()"

if vim.fn.executable("rg") == 1 then
    vim.opt.grepprg = "rg --vimgrep --smart-case"
end
