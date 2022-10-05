local opts = { noremap = true, silent = true }

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
vim.keymap.set('n', '<space>tb', ":Telescope buffers<CR>", opts)

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

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(_, bufnr)
    -- Enable completion triggered by <c-x><c-o>
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local bufopts = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
    vim.keymap.set('n', 'gd', require("telescope.builtin").lsp_definitions, opts)
    vim.keymap.set('n', 'gr', require("telescope.builtin").lsp_references, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
    vim.keymap.set('n', 'L', vim.lsp.buf.signature_help, bufopts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
    vim.keymap.set('n', '<space>wl', function()

        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, bufopts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
    vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
    vim.keymap.set('n', '<space>b', ":lua vim.lsp.buf.format { async = true }<CR>", bufopts)
end

return {
    on_attach = on_attach
}
