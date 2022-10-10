
local map = vim.keymap.set
vim.g.mapleader = ' '
local opts = { noremap = true, silent = true }

local telescope = {
    buffers = {
        mappings = {
            -- delete buffer from menu
            n = {
                ['<C-d>'] = require('telescope.actions').delete_buffer
            },
            i = {
                ['<C-d>'] = require('telescope.actions').delete_buffer
            }
        }
    }
}
map("n", "<esc>", ":noh<CR>", opts)
map("n", "]b", ":bn<CR>", opts)
map("n", "[b", ":bp<CR>", opts)

-- so shift-tab works
map("i", "<S-Tab>", "<C-d>", opts)

map("n", "<leader>q", "q")
map("n", "<leader>Q", "Q")
-- never talk to me or my s key ever again
map("n", "q", "<Plug>Lightspeed_s", opts)
map("n", "Q", "<Plug>Lightspeed_S", opts)
map("x", "q", "<Plug>Lightspeed_s", opts)
map("x", "Q", "<Plug>Lightspeed_S", opts)

-- telescope
map('n', '<leader>ss', require("telescope.builtin").lsp_document_symbols, opts)
map('n', '<leader>sp', require("telescope.builtin").lsp_workspace_symbols, opts)
map('n', '<leader>ee', (function() require("telescope.builtin").diagnostics { bufnr = 0 } end), opts)
map('n', '<leader>ep', require("telescope.builtin").diagnostics, opts)
-- telecsope menu
map('n', '<leader>tt', require("telescope.builtin").builtin, opts)
-- files
map('n', '<leader>tp', ":Telescope projects<CR>", opts)
map('n', '<leader>fp', require("utils").find_files_in_root
   , opts)
map('n', '<leader>ff', require("telescope.builtin").find_files, opts)
map('n', '<leader>fb', ":Neotree", opts)
map('n', '<leader>fr', ":Telescope oldfiles<CR>", opts)
map('n', '<leader>fg', require("telescope.builtin").git_files, opts)
map('n', '<leader>b', ":Telescope buffers<CR>", opts)

-- text search
map('n', '<leader>zz', ":Telescope current_buffer_fuzzy_find<CR>", opts)
-- get all text and use fuzzy as a sorter
map('n', '<leader>zp',
    (
    function() require('telescope.builtin').grep_string { shorten_path = true, word_match = "-w", only_sort_text = true,
            search = '' }
    end)
    , opts)

-- lsp
map('n', '[d', vim.diagnostic.goto_prev, opts)
map('n', ']d', vim.diagnostic.goto_next, opts)
map('n', '<leader>ne', ":Neorg<CR>", opts)

local on_attach = function(_, bufnr)
    --    -- Enable completion triggered by <c-x><c-o>
    --    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
    -- lspsaga
    --    finder_action_keys = {
    --    open = "o",
    --    vsplit = "s",
    --    split = "i",
    --    tabe = "t",
    --    quit = "q",
    --},
    --code_action_keys = {
    --    quit = "q",
    --    exec = "<CR>",
    --},
    --definition_action_keys = {
    --  edit = '<C-c>o',
    --  vsplit = '<C-c>v',
    --  split = '<C-c>i',
    --  tabe = '<C-c>t',
    --  quit = 'q',
    --},
    -- Mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local bufopts = { noremap = true, silent = true, buffer = bufnr }
    map('n', 'gl', "<cmd>Lspsaga lsp_finder<CR>", bufopts)
    map('n', '<leader>gd', "<cmd>Lspsaga peek_definition<CR>", opts)
    map('n', '<leader>rn', "<cmd>Lspsaga rename<CR>", bufopts)
    map('n', '<leader>ca', "<cmd>Lspsaga code_action<CR>", bufopts)
    map('n', 'K', "<cmd>Lspsaga hover_doc<CR>", bufopts)
    map('n', 'gD', vim.lsp.buf.declaration, bufopts)
    map('n', 'gd', require("telescope.builtin").lsp_definitions, opts)
    map('n', 'gr', require("telescope.builtin").lsp_references, opts)
    map('n', 'L', vim.lsp.buf.signature_help, bufopts)
    map('n', 'gi', vim.lsp.buf.implementation, bufopts)
    map('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, bufopts)
    map('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
    map('n', '<leader>wl', function()

        print(vim.inspect(vim.lsp.buf.list_workleader_folders()))
    end, bufopts)
    map('n', '<leader>D', vim.lsp.buf.type_definition, bufopts)
    map('n', '<leader>p', ":lua vim.lsp.buf.format { async = true }<CR>", bufopts)
end

return {
    on_attach = on_attach,
    telescope = telescope
}
