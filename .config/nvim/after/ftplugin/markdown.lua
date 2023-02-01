
vim.bo.fo = vim.bo.fo -- ruining my snippets
vim.bo.textwidth =  98 -- exactly width of a vertically split tmux pane
vim.go.autowrite = true


-- https://github.com/jose-elias-alvarez/null-ls.nvim/issues/1131
local bufnr = vim.api.nvim_get_current_buf()
vim.api.nvim_buf_set_option(bufnr, "formatexpr", "")

