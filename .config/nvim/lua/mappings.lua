local map = vim.keymap.set
vim.g.mapleader = ' '

-- used for conjure, also:
-- https://www.reddit.com/r/vim/comments/bkfaff/localleader_what_are_you_guys_using_this_for/
vim.g.localmapleader = '\\'
local opts = { noremap = true, silent = true }

-- to avoid evaluating requires right away
local telescope_lazy = function()
    return {
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
end

local nvim_treesitter = {
    incremental_selection = {
        keymaps = {
            init_selection = "gsi",
            node_incremental = "gsn",
            scope_incremental = "gsc",
            node_decremental = "gsd",
        }
    }
}

local cmp = {
    mapping = require("cmp").mapping.preset.insert({
        ["<Tab>"] = require("cmp").mapping(function(fallback)
            if require("cmp").visible() then
                require("cmp").select_next_item()
            elseif require("luasnip").expand_or_jumpable() then
                return require("luasnip").expand_or_jump()
            else
                fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
            end
        end, { "n", "i", "s" }),

        ["<S-Tab>"] = require("cmp").mapping(function(fallback)
            if require("cmp").visible() then
                require("cmp").select_prev_item()
            elseif require("luasnip").jumpable(-1) then
                return require("luasnip").jump(-1)
            else
                fallback()
            end
        end, { "i", "s" })
        ,
        ['<C-Space>'] = require("cmp").mapping.complete(),
        ['<C-x>'] = require("cmp").mapping.abort(),
        ['<CR>'] = require("cmp").mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    })
}

map("n", "<esc>", ":noh<CR>", opts)
map("n", "]b", ":bn<CR>", opts)
map("n", "[b", ":bp<CR>", opts)

-- so shift-tab works
map("i", "<S-Tab>", "<C-d>", opts)

map("n", "<leader>q", "q", opts)
map("n", "<leader>Q", "Q", opts)
-- never talk to me or my s key ever again
map({ "n", "x", "o" }, "q", "<Plug>(leap-forward-to)", opts)
map({ "n", "x", "o" }, "Q", "<Plug>(leap-backward-to)", opts)
map({ "x", "o" }, "q", "<Plug>(leap-forward-till)", opts)
map({ "x", "o" }, "Q", "<Plug>(leap-backward-till)", opts)
map({ "n", "x", "o" }, "<C-q>", "<Plug>(leap-cross-window)", opts)

-- telescope
-- if i change lua functions to vim string, can make telescope lazily loaded
-- telecsope menu
map('n', '<leader>tt', ":Telescope<CR>", opts)
-- files
map('n', '<leader>tp', ":Telescope projects<CR>", opts)
map('n', '<leader>tr', ":Telescope resume<CR>", opts)
map('n', '<leader>fp', require("utils").find_files_in_root
    , opts)
map('n', '<leader>ff', ":Telescope find_files<CR>", opts)
map('n', '<leader>fb', ":Neotree position=left toggle=true action=focus<CR>", opts)
map('n', '<leader>fr', ":Telescope oldfiles<CR>", opts)
map('n', '<leader>fg', ":Telescope git_files<CR>", opts)
map('n', '<leader>b', ":Telescope buffers<CR>", opts)
-- AFAIK, both :Rg and :Ag do pretty much what grep_string does, they search for something and feed the matches (or feed the entire lines of the project when used with no search string) to Telescope to be fuzzy searched.
-- live_grep is a different story, each keystroke generates a new rg (or ag) command and the results are returned to Telescope, there's no fuzzy search here but rather a regex search of the typed query.

-- text search
map('n', '<leader>zz', ":Telescope current_buffer_fuzzy_find<CR>", opts)
-- get all text and use fuzzy as a sorter
map('n', '<leader>zp',
    ':Telescope grep_string shorten_path=true only_sort_text=true search=""<CR>'
    , opts)

-- lsp
map('n', '<leader>ne', ":Neorg<CR>", opts)

local on_attach = function(_, bufnr)
    local bufopts = {}
    map('n', ']d', "<cmd>Lspsaga diagnostic_jump_next<CR>", opts)
    map('n', '[d', "<cmd>Lspsaga diagnostic_jump_prev<CR>", opts)
    map("n","gO", "<cmd>LSoutlineToggle<CR>",opts)
    map('n', '<leader>dc', "<cmd>Lspsaga show_line_diagnostics<CR>", opts)
    map('n', 'gl', "<cmd>Lspsaga lsp_finder<CR>", bufopts)
    map('n', '<leader>pd', "<cmd>Lspsaga peek_definition<CR>", opts)
    map('n', '<leader>rn', "<cmd>Lspsaga rename<CR>", bufopts)
    map('n', '<leader>ca', "<cmd>Lspsaga code_action<CR>", bufopts)
    map('n', '<leader>td', vim.lsp.buf.type_definition, bufopts)
    map('n', '<leader>p', ":lua vim.lsp.buf.format { async = true }<CR>", bufopts)
    map('n', '<leader>ss', ":Telescope lsp_document_symbols<CR>", opts)
    map('n', '<leader>sp', ":Telescope lsp_dynamic_workspace_symbols<CR>", opts)
    map('n', '<leader>dd', ":Telescope diagnostics bufnr=0<CR>", opts)
    map('n', '<leader>dp', ":Telescope diagnostics<CR>", opts)
    --- these are leaderless to be consistent with defaults and vim built ins
    map('n', 'gD', vim.lsp.buf.declaration, bufopts)
    map('n', 'K', "<cmd>Lspsaga hover_doc<CR>", bufopts)
    map('n', 'gd', ":Telescope lsp_definitions<CR>", opts)
    map('n', 'gr', ":Telescope lsp_references<CR>", opts)
    map('n', 'L', vim.lsp.buf.signature_help, bufopts)
    map('n', '<leader>gi', vim.lsp.buf.implementation, bufopts)
    map('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, bufopts)
    map('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
    map('n', '<leader>wl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, bufopts)
end

return {
    on_attach       = on_attach,
    telescope_lazy  = telescope_lazy,
    nvim_treesitter = nvim_treesitter,
    cmp             = cmp,
}
