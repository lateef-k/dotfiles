local function keymap()
    return {
        mapping = require("cmp").mapping.preset.insert({
            ["<Tab>"] = require("cmp").mapping(function(fallback)
                if require("cmp").visible() then
                    require("cmp").select_next_item()
                else
                    fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
                end
            end, { "n", "i", "s" }),
            ["<S-Tab>"] = require("cmp").mapping(function(fallback)
                if require("cmp").visible() then
                    require("cmp").select_prev_item()
                else
                    fallback()
                end
            end, { "i", "s" }),
            -- gh to r-enter select mode and continue selecting
            ["<M-j>"] = require("cmp").mapping(function(fallback)
                if require("luasnip").expand_or_jumpable() then
                    return require("luasnip").expand_or_jump()
                else
                    fallback()
                end
            end, { "n", "i", "s" }),

            ["<M-k>"] = require("cmp").mapping(function(fallback)
                if require("luasnip").jumpable( -1) then
                    return require("luasnip").jump( -1)
                else
                    fallback()
                end
            end, { "n", "i", "s" }),

            ["<M-l>"] = require("cmp").mapping(function(fallback)
                if require("luasnip").choice_active() then
                    return require("luasnip").change_choice(1)
                else
                    fallback()
                end
            end, { "n", "i", "s" }),
            ["<M-h>"] = require("cmp").mapping(function(fallback)
                if require("luasnip").choice_active() then
                    return require("luasnip").change_choice( -1)
                else
                    fallback()
                end
            end, { "n", "i", "s" }),
            ["<C-Space>"] = require("cmp").mapping.complete(),
            ["<C-x>"] = require("cmp").mapping.abort(),
            ["<CR>"] = require("cmp").mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        }),
    }
end

local function config()
    -- Set up nvim-cmp.
    local cmp = require("cmp")
    cmp.setup({
        snippet = {
            -- REQUIRED - you must specify a snippet engine
            expand = function(args)
                require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
            end,
        },
        window = {
            completion = cmp.config.window.bordered(),
            documentation = cmp.config.window.bordered(),
        },
        mapping = keymap().mapping,
        sources = cmp.config.sources({
            { name = "luasnip" }, -- For luasnip users.
            { name = "nvim_lsp" },
            { name = "neorg" },
            { name = "nvim_lsp_signature_help" },
        }, {
            { name = "path" },
            { name = "buffer" },
        }),
    })

    -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
    -- i.e completions when searching
    cmp.setup.cmdline("/", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
            { name = "buffer" },
        },
    })

    -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
    -- completions in command mode
    cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
            { name = "path" },
        }, {
            { name = "cmdline" },
        }),
    })
end

return {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
        { "hrsh7th/cmp-buffer" },
        { "hrsh7th/cmp-path" },
        { "hrsh7th/cmp-cmdline" },
        { "saadparwaiz1/cmp_luasnip" },
        { "hrsh7th/cmp-nvim-lsp" },
        { "hrsh7th/cmp-nvim-lsp-signature-help" },
    },
    config = config,
}
