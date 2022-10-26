require('impatient')
vim.opt.relativenumber = true

-- vim.opt if for things you would set in vimscript. vim.g is for things you'd let.

vim.opt.tabstop = 4 -- tabs should equal 4 characters
vim.opt.shiftwidth = 4 -- >> will shift by 4 characters
vim.opt.expandtab = true -- use space char for tabbing
vim.opt.smarttab = true
vim.opt.wrap = true -- soft tab
vim.opt.scrolloff = 999 -- keep cursor in center
vim.opt.clipboard:append { 'unnamedplus' } -- use system clipboard
vim.opt.switchbuf:append { "usetab", "newtab" } -- switch to tab if exists rather than create
vim.opt.shortmess:append("I") --disable intro
vim.opt.completeopt = "menu,menuone,noselect,noinsert"

vim.opt.termbidi = true
vim.opt.cursorline = true

vim.opt.undofile = true
vim.opt.undodir = vim.fn.expand('~/.cache/nvim/undodir')

-- lower and uppercase search, unless uppercase
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require('plugins')
require('utils')
require('mappings')

-- follow the active file's working dir
vim.api.nvim_exec([[
    augroup chdir
        autocmd BufEnter * silent! lcd %:p:h
    augroup END
    augroup openNeotree
        autocmd BufEnter * ++once if isdirectory(expand("%")) | enew | Neotree 
    augroup END
]], false)

vim.opt.foldmethod = "expr"
