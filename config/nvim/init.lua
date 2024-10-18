--
--                                                 *grr* *gra* *grn* *i_CTRL-S*
-- Some keymaps are created unconditionally when Nvim starts:
-- - "grn" is mapped in Normal mode to |vim.lsp.buf.rename()|
-- - "gra" is mapped in Normal and Visual mode to |vim.lsp.buf.code_action()|
-- - "grr" is mapped in Normal mode to |vim.lsp.buf.references()|
-- - CTRL-S is mapped in Insert mode to |vim.lsp.buf.signature_help()|
--
--
-- - 'omnifunc' is set to |vim.lsp.omnifunc()|, use |i_CTRL-X_CTRL-O| to trigger
--   completion.
-- - 'tagfunc' is set to |vim.lsp.tagfunc()|. This enables features like
--   go-to-definition, |:tjump|, and keymaps like |CTRL-]|, |CTRL-W_]|,
--   |CTRL-W_}| to utilize the language server.
-- - 'formatexpr' is set to |vim.lsp.formatexpr()|, so you can format lines via
--   |gq| if the language server supports it.
--   - To opt out of this use |gw| instead of gq, or clear 'formatexpr' on |LspAttach|.
-- - |K| is mapped to |vim.lsp.buf.hover()| unless |'keywordprg'| is customized or
--   a custom keymap for `K` exists.
--

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- Colorscheme
vim.cmd("colorscheme retrobox")

-- Options
vim.opt.cmdheight = 0
vim.opt.undofile = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.smartcase = true
vim.opt.ignorecase = true
vim.opt.smartindent = true
vim.opt.clipboard = "unnamedplus"
vim.opt.grepprg = "rg --vimgrep --smart-case"
vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

-- Folding Options
vim.opt.fillchars = { fold = " " }
vim.opt.foldmethod = "indent"
vim.opt.foldenable = false
vim.opt.foldlevel = 99
vim.g.markdown_folding = 1 -- enable markdown folding

-- Mapping (not including plugins)

vim.g.mapleader = " "

local map = vim.keymap.set
local opts = { noremap = true, silent = true }
map({ "i", "t" }, "jk", "<Esc>", { desc = "Exit insert/terminal mode with 'jk'" })
map({ "i", "t" }, "kj", "<Esc>", { desc = "Exit insert/terminal mode with 'kj'" })
map("n", "]b", "<cmd>bnext<CR>", { desc = "Go to the next buffer" })
map("n", "[b", "<cmd>bprevious<CR>", { desc = "Go to the previous buffer" })
map("n", "]q", "<cmd>cnext<CR>", { desc = "Go to the next quickfix item" })
map("n", "[q", "<cmd>cprevious<CR>", { desc = "Go to the previous quickfix item" })
map("n", "grd", function()
	vim.diagnostic.open_float(nil, { scope = "line" })
end, { desc = "Show diagnostics for the current line in a floating window", unpack(opts) })
vim.g["diagnostics_active"] = true
map("n", "<leader>td", function()
	if vim.g.diagnostics_active then
		vim.g.diagnostics_active = false
		vim.diagnostic.enable(false)
	else
		vim.g.diagnostics_active = true
		vim.diagnostic.enable()
	end
end, { desc = "Toggle diagnostics on and off" })

-- AutoCmds
local autocmd = vim.api.nvim_create_autocmd
autocmd("FileType", {
	pattern = "nix",
	command = "setlocal tabstop=2 shiftwidth=2 softtabstop=2",
})
autocmd("FileType", {
	pattern = "lua",
	command = "setlocal tabstop=4 shiftwidth=4 softtabstop=4",
})
autocmd("TextYankPost", {
	pattern = "*",
	callback = function()
		vim.highlight.on_yank({ higroup = "Visual", timeout = 500 })
	end,
})
-- Commands
local command = vim.api.nvim_create_user_command
-- Setup lazy.nvim
require("lazy").setup(require("plugins"))
