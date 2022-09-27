vim.opt.relativenumber = true

vim.opt.tabstop = 4 -- tabs should equal 4 characters
vim.opt.shiftwidth =4 -- >> will shift by 4 characters
vim.opt.expandtab = true -- use space char for tabbing
vim.opt.smarttab = true
vim.opt.wrap = true -- soft tab
vim.opt.scrolloff=999 -- keep cursor in center
vim.opt.clipboard:append { 'unnamedplus' } -- use system clipboard
vim.opt.switchbuf:append { "usetab", "newtab" } -- switch to tab if exists rather than create
vim.opt.completeopt = "menu,menuone,noselect,noinsert"

vim.opt.termbidi = true

vim.opt.undofile = true
vim.opt.undodir = '/home/alf/.cache/nvim/undodir'

require('plugins')
require('languages')
require('helper')
require('mappings')
require('mods')

Today = require('helper').today
