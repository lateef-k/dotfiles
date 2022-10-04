local helper = require("helper")

return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'
    --
    use 'christoomey/vim-tmux-navigator'

    -- repeats whole commands, not just last component of command
    -- try ys_{ then . without this, won't wokr properly
    use 'tpope/vim-surround'
    use 'tpope/vim-repeat'
    use 'lukas-reineke/indent-blankline.nvim'
    use "windwp/nvim-autopairs"

    use 'mbbill/undotree'

    use 'jpalardy/vim-slime'

    use 'nvim-lualine/lualine.nvim'

    use 'tpope/vim-fugitive'
    use 'lewis6991/gitsigns.nvim'

    use 'neovim/nvim-lspconfig'
    use 'williamboman/mason.nvim'
    use 'williamboman/mason-lspconfig.nvim'
    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate'
    }

    use {
        'nvim-telescope/telescope.nvim',
        commit = "30e2dc5", -- fix fuzzy find
        requires = { { 'nvim-lua/plenary.nvim', 'kyazdani42/nvim-web-devicons' } }
    }
    use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
    use { "nvim-telescope/telescope-file-browser.nvim" }

    use 'hrsh7th/nvim-cmp'
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-path'
    use 'hrsh7th/cmp-cmdline'
    use 'saadparwaiz1/cmp_luasnip'

    use 'L3MON4D3/LuaSnip'

    use "folke/lua-dev.nvim"

    use "jose-elias-alvarez/null-ls.nvim"

    use { "catppuccin/nvim", as = "catppuccin" }

    -- Lua
    use "ahmedkhalf/project.nvim"


    use {
        "nvim-neorg/neorg",
        requires = "nvim-lua/plenary.nvim"
    }

    -- setup functions
    --
    require('nvim-autopairs').setup()
    -- Lualine
    ------------------------------------------------------------------------------------------
    require('plugins_setup.config_lualine')

    -- Vim Slime
    ------------------------------------------------------------------------------------------
    vim.g.slime_target = "tmux"
    vim.g.slime_paste_file = vim.fn.tempname()
    -- so that the command is always sent to the other pane
    vim.g.slime_default_config = {
        socket_name = helper.split(os.getenv("TMUX"), ",")[1],
        target_pane = "{next}"
    }

    -- this will manage all external LSP/code formatters etc
    require("mason").setup()
    require("mason-lspconfig").setup()

    ------------------------------ Telescope
    local telescopeConfig = require("telescope.config")
    -- Clone the default Telescope configuration
    local vimgrep_arguments = { unpack(telescopeConfig.values.vimgrep_arguments) }
    -- I want to search in hidden/dot files.
    table.insert(vimgrep_arguments, "--hidden")
    -- I don't want to search in the `.git` directory.
    table.insert(vimgrep_arguments, "--glob")
    table.insert(vimgrep_arguments, "!**/.git/*")
    require('telescope').setup {
        defaults = {
            -- this is what's fed to ripgrep
            -- `hidden = true` is not supported in text grep commands.
            vimgrep_arguments = vimgrep_arguments,
        },
        pickers = {
            find_files = {
                find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
            }

        },
        extensions = {
            fzf = {
                fuzzy = true, -- false will only do exact matching
                override_generic_sorter = true, -- override the generic sorter
                override_file_sorter = true, -- override the file sorter
                case_mode = "smart_case", -- or "ignore_case" or "respect_case"
                -- the default case_mode is "smart_case"
            }
        }
    }
    --------------------------------
    require 'nvim-web-devicons'.setup({
        -- globally enable default icons (default to false)
        -- will get overriden by `get_icons` option
        default = true;
    })
    require('telescope').load_extension("projects")
    require('telescope').load_extension("fzf")
    require("telescope").load_extension("file_browser")

    require("lua-dev").setup()

    require("luasnip.loaders.from_snipmate").lazy_load()

    require("null-ls").setup({
        sources = {
            require("null-ls").builtins.formatting.black,
            require("null-ls").builtins.formatting.prettier,
        },
        on_attach = require("mappings").on_attach
    })
    require("catppuccin").setup({
        dim_inactive = {
            enabled = true,
            shade = "dark",
            percentage = 0.15,
        },
    })
    vim.g.catppuccin_flavour = "macchiato" -- latte, frappe, macchiato, mocha
    vim.cmd("colorscheme catppuccin")


    require("project_nvim").setup({
        show_hidden = true,
        manual_mode = true,
    })

    require("nvim-treesitter.configs").setup({
        -- A list of parser names, or "all"
        ensure_installed = { "python", "lua", "norg" },
        highlight = { -- Be sure to enable highlights if you haven't!
            enable = true,
        },

        -- Install parsers synchronously (only applied to `ensure_installed`)
        sync_install = false,

        -- Automatically install missing parsers when entering buffer
        auto_install = true,
    })


    require('neorg').setup {
        load = {
            ["core.defaults"] = {},
            ["core.norg.dirman"] = {
                config = {
                    workspaces = {
                        projects = "~/Documents/Library/Org/projects",
                        notes = "~/Documents/Library/Org/notes",
                        machine = "~/Documents/Library/Org/machine",
                    }
                }
            },
            ["core.norg.completion"] = {
                config = {
                    engine = "nvim-cmp"
                }
            },
            ["core.norg.qol.toc"] = {
            },
            ["core.norg.concealer"] = {
            }
        }
    }

end)
