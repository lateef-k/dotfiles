-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

local function augroup(name)
  return vim.api.nvim_create_augroup("latif_" .. name, { clear = true })
end

vim.api.nvim_create_autocmd("FileType", {
  group = augroup("fugitive"),
  pattern = {
    "fugitive",
  },
  callback = function(event)
    -- vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "<leader>gg", "<cmd>close<cr>", { buffer = event.buf, silent = true })
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = augroup("oil"),
  pattern = {
    "oil",
  },
  callback = function(event)
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})
