-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--
local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- DELETE THESE KEY MAPS
vim.keymap.del("n", "<C-/>", opts)
vim.keymap.del("n", "<C-_>", opts)

-- EXIT NORMAL MODE
map({ "i", "t" }, "jk", "<Esc>", opts)
map({ "i", "t" }, "kj", "<Esc>", opts)

-- GIT
map({ "n" }, "<leader>gg", "<cmd>Git<CR>", opts)

-- TMUX
map(
  { "i", "n", "v" },
  "<C-k>",
  "<cmd>NvimTmuxNavigateUp<cr><esc>",
  { desc = "Move cursor to top pane", noremap = true, silent = true }
)
map(
  { "i", "n", "v" },
  "<C-j>",
  "<cmd>NvimTmuxNavigateDown<cr><esc>",
  { desc = "Move cursor to bottom pane", noremap = true, silent = true }
)
map(
  { "i", "n", "v" },
  "<C-h>",
  "<cmd>NvimTmuxNavigateLeft<cr><esc>",
  { desc = "Move cursor to left pane", noremap = true, silent = true }
)
map(
  { "i", "n", "v" },
  "<C-l>",
  "<cmd>NvimTmuxNavigateRight<cr><esc>",
  { desc = "Move cursor to right pane", noremap = true, silent = true }
)
