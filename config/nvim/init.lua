-- DEFAULTS                                                *lsp-defaults*
--
-- When the Nvim LSP client starts it enables diagnostics |vim.diagnostic| (see
-- |vim.diagnostic.config()| to customize). It also sets various default options,
-- listed below, if (1) the language server supports the functionality and (2)
-- the options are empty or were set by the builtin runtime (ftplugin) files. The
-- options are not restored when the LSP client is stopped or detached.
--
-- GLOBAL DEFAULTS
--                                 *grr* *gra* *grn* *gri* *grt* *i_CTRL-S* *an* *in*
-- These GLOBAL keymaps are created unconditionally when Nvim starts:
-- - "grn" is mapped in Normal mode to |vim.lsp.buf.rename()|
-- - "gra" is mapped in Normal and Visual mode to |vim.lsp.buf.code_action()|
-- - "grr" is mapped in Normal mode to |vim.lsp.buf.references()|
-- - "gri" is mapped in Normal mode to |vim.lsp.buf.implementation()|
-- - "grt" is mapped in Normal mode to |vim.lsp.buf.type_definition()|
-- - "gO" is mapped in Normal mode to |vim.lsp.buf.document_symbol()|
-- - CTRL-S is mapped in Insert mode to |vim.lsp.buf.signature_help()|
-- - "an" and "in" are mapped in Visual mode to outer and inner incremental
--   selections, respectively, using |vim.lsp.buf.selection_range()|
--   diagnostics: ctrl-w d
--
-- BUFFER-LOCAL DEFAULTS
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
vim.opt.splitright = true
vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

-- Folding Options
vim.opt.fillchars = { fold = " " }
vim.opt.foldmethod = "indent"
vim.opt.foldenable = false
vim.opt.foldlevel = 99
vim.opt.conceallevel = 1
vim.g.markdown_folding = 1 -- enable markdown folding
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.diagnostic.config({
	-- Use the default configuration

	-- Alternatively, customize specific options
	virtual_lines = {
		--  -- Only show virtual line diagnostics for the current cursor line
		current_line = true,
	},
})

-- Mapping (not including plugins)

vim.g.mapleader = " "
local map = vim.keymap.set
local opts = { noremap = true, silent = true }
map({ "i", "t" }, "jk", "<Esc>", { desc = "Exit insert/terminal mode with 'jk'" })
map({ "i", "t" }, "kj", "<Esc>", { desc = "Exit insert/terminal mode with 'kj'" })

vim.g["diagnostics_active"] = true
vim.api.nvim_create_user_command("ToggleDiagnostics", function()
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
autocmd("FileType", {
	pattern = { "typescript", "javascript", "typescriptreact", "javascriptreact" },
	command = "setlocal tabstop=2 shiftwidth=2 softtabstop=2",
})
autocmd("TextYankPost", {
	pattern = "*",
	callback = function()
		vim.highlight.on_yank({ higroup = "Visual", timeout = 500 })
	end,
})
-- Auto commands for saving and loading folds
autocmd("BufWinLeave", {
	pattern = "*.*",
	command = "mkview",
})

autocmd("BufWinEnter", {
	pattern = "*.*",
	command = "silent! loadview",
})
autocmd({ "FocusGained", "FocusLost" }, { -- resize when created new tmux panes
	pattern = "*",
	command = "silent! wincmd =",
})
-- Commands
local command = vim.api.nvim_create_user_command
-- Setup lazy.nvim
require("lazy").setup(require("plugins"))

--- LSPs
---
-- 	"neovim/nvim-lspconfig",
-- 	config = function()
-- 		local lspconfig = require("lspconfig")
-- 		local servers = {
-- 			"pyright",
-- 			"nixd",
-- 			"lua_ls",
-- 			"bashls",
-- 			"ts_ls",
-- 		}
-- 		for _, lsp in ipairs(servers) do
-- 			lspconfig[lsp].setup({})
-- 		end
--
-- 		-- print(vim.inspect(lspconfig["ruff_lsp"]))

-- vim.lsp.config("basedpyright", {
-- 	settings = {
-- 		basedpyright = {
-- 			analysis = {
-- 				typeCheckingMode = "standard",
-- 			},
-- 		},
-- 	},
-- })
-- vim.lsp.enable("basedpyright")
vim.lsp.enable("pyright")
vim.lsp.enable("nixd")
vim.lsp.enable("lua_ls")
vim.lsp.enable("bashls")
vim.lsp.enable("ts_ls")
vim.lsp.enable("gopls")
