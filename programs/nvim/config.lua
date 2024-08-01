if os.getenv("TMUX") then
	vim.opt.clipboard:append("unnamedplus")
	vim.g.clipboard = {
		name = "tmux",
		copy = {
			["+"] = "tmux load-buffer -",
			["*"] = "tmux load-buffer -",
		},
		paste = {
			["+"] = "tmux save-buffer -",
			["*"] = "tmux save-buffer -",
		},
		cache_enabled = 1,
	}
end

vim.opt.cmdheight = 0
vim.opt.undofile = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.smartcase = true
vim.opt.smartindent = true

local map = vim.keymap.set
local opts = { noremap = true, silent = true }
map({ "i", "t" }, "jk", "<Esc>", opts)
map({ "i", "t" }, "kj", "<Esc>", opts)
