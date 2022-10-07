local opts = { noremap = true, silent = true }


vim.keymap.set("n", "]b", ":bn<CR>", opts)
vim.keymap.set("n", "[b", ":bp<CR>", opts)

-- so shift-tab works
vim.keymap.set("i", "<S-Tab>", "<C-d>", opts)

-- telescope
vim.keymap.set('n', '<space>ss', require("telescope.builtin").lsp_document_symbols, opts)
vim.keymap.set('n', '<space>sp', require("telescope.builtin").lsp_workspace_symbols, opts)
vim.keymap.set('n', '<space>ee', (function() require("telescope.builtin").diagnostics { bufnr = 0 } end), opts)
vim.keymap.set('n', '<space>ep', require("telescope.builtin").diagnostics, opts)
-- telecsope menu
vim.keymap.set('n', '<space>tt', require("telescope.builtin").builtin, opts)
-- files
vim.keymap.set('n', '<space>tp', ":Telescope projects<CR>", opts)
vim.keymap.set('n', '<space>fp',
    function()
        local root = require("project_nvim.project").get_project_root()
        if root ~= nil then
            require("telescope.builtin").find_files {
                cwd = root
            }
        else
            print("No root found")
        end
    end, opts)
vim.keymap.set('n', '<space>ff', require("telescope.builtin").find_files, opts)
vim.keymap.set('n', '<space>fb', ":Telescope file_browser<CR>", opts)
vim.keymap.set('n', '<space>fr', ":Telescope oldfiles<CR>", opts)
vim.keymap.set('n', '<space>fg', require("telescope.builtin").git_files, opts)
vim.keymap.set('n', '<space>b', ":Telescope buffers<CR>", opts)

-- text search
vim.keymap.set('n', '<space>zz', ":Telescope current_buffer_fuzzy_find<CR>", opts)
-- get all text and use fuzzy as a sorter
vim.keymap.set('n', '<space>zp',
    (
    function() require('telescope.builtin').grep_string { shorten_path = true, word_match = "-w", only_sort_text = true,
            search = '' }
    end)
    , opts)

-- lsp
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>ne', ":Neorg<CR>", opts)

local on_attach = function(_, bufnr)
    --    -- Enable completion triggered by <c-x><c-o>
    --    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
    --
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
    vim.keymap.set('n', '<space>gf', "<cmd>Lspsaga lsp_finder<CR>", bufopts)
    vim.keymap.set('n', '<space>gd', "<cmd>Lspsaga peek_definition<CR>", opts)
    vim.keymap.set('n', '<space>rn', "<cmd>Lspsaga rename<CR>", bufopts)
    vim.keymap.set('n', '<space>ca', "<cmd>Lspsaga code_action<CR>", bufopts)
    vim.keymap.set('n', 'K', "<cmd>Lspsaga hover_doc<CR>", bufopts)
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
    vim.keymap.set('n', 'gd', require("telescope.builtin").lsp_definitions, opts)
    vim.keymap.set('n', 'gr', require("telescope.builtin").lsp_references, opts)
    vim.keymap.set('n', 'L', vim.lsp.buf.signature_help, bufopts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
    vim.keymap.set('n', '<space>wl', function()

        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, bufopts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
    vim.keymap.set('n', '<space>p', ":lua vim.lsp.buf.format { async = true }<CR>", bufopts)
end

return {
    on_attach = on_attach
}
