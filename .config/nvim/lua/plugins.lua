local utils = require("utils")

vim.api.nvim_exec([[

]], false)
vim.cmd [[packadd packer.nvim]]
return require('packer').startup(function(use)
    -- Packer can manage itself
    use { 'wbthomason/packer.nvim', opt = true }
    use { 'christoomey/vim-tmux-navigator' }
    -- repeats whole commands, not just last component of command
    -- try ys_{ then . without this, won't wokr properly
    use { 'tpope/vim-surround', keys = {
        { "n", "y" },
    } }
    use { 'tpope/vim-repeat' }
    use { 'lukas-reineke/indent-blankline.nvim' }
    use { "windwp/nvim-autopairs", event = "InsertEnter",
        config = function()
            require('nvim-autopairs').setup()
        end
    }
    use { 'mbbill/undotree',
        cmd = { "UndotreeToggle", "UndotreeFocus", "UndotreeHide", "UndotreeShow" }
    }
    use { 'jpalardy/vim-slime',
        keys = { { "n", "<C-c><C-c>" }, { "v", "<C-c><C-c>" }, { "n", "<C-c>v" } },
        config = function()
            vim.g.slime_target = "tmux"
            vim.g.slime_paste_file = vim.fn.tempname()
            vim.g.slime_default_config = {
                socket_name = utils.split(os.getenv("TMUX"), ",")[1],
                target_pane = "{next}"
            }
        end
    }
    use { 'nvim-lualine/lualine.nvim',
        config = function()
            require('config.lualine')
        end
    }
    use { 'tpope/vim-fugitive', cmd = {
        "Git", "Gsplit", "Gedit", "Gdiffsplit", "Gread", "Gwrite", "Ggrep", "GMove", "GDelete", "GBrowse",
    }
    }
    use { 'lewis6991/gitsigns.nvim' }
    use {
        'hrsh7th/nvim-cmp',
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-path',
        'hrsh7th/cmp-cmdline',
        'saadparwaiz1/cmp_luasnip',
        'hrsh7th/cmp-nvim-lsp',
    }
    use {
        'L3MON4D3/LuaSnip',
        config = function()
            require("luasnip.loaders.from_snipmate").lazy_load()
        end
    }


    -- this sequencing is for mason-lspconfig
    use {
        'williamboman/mason.nvim',
        cmd = {
            "Mason", "MasonInstall", "MasonUninstall", "MasonUninstallAll", "MasonLog",
        },
        module = "lspconfig",
        config = function()
            require("mason").setup()
        end,
    }
    use {
        'williamboman/mason-lspconfig.nvim',
        after = "mason.nvim",
        cmd = {
            "LspInstall", "LspUninstall",
        },
        config = function()
            require("mason-lspconfig").setup()
        end
    }
    use {
        'neovim/nvim-lspconfig',
        after = "mason-lspconfig.nvim",
        cmd = {
            "LspLog", "LspInfo", "LspStart", "LspStop", "LspRestart"
        },
    }
    use { "jose-elias-alvarez/null-ls.nvim",
        after = "nvim-lspconfig",
        config = function()
            require("null-ls").setup({
                sources = {
                    require("null-ls").builtins.formatting.black,
                    require("null-ls").builtins.formatting.prettier,
                },
                on_attach = require("mappings").on_attach
            })
        end
    }
    use({
        "glepnir/lspsaga.nvim",
        after = "nvim-lspconfig",
        branch = "main",
        config = function()
            local saga = require("lspsaga")
            saga.init_lsp_saga({
                -- your configuration
            })
        end,
    })
    --

    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate'
    }


    use {
        'nvim-telescope/telescope.nvim',
        requires = { { 'nvim-lua/plenary.nvim', 'kyazdani42/nvim-web-devicons' } },
    }
    use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make',
    }
    require("config.telescope")

    use { "folke/lua-dev.nvim",
        module = "lua-dev"
    }

    use { "catppuccin/nvim", as = "catppuccin",
        config = function()
            require("catppuccin").setup({
                dim_inactive = {
                    enabled = true,
                    shade = "dark",
                    percentage = -1.15,
                },
            })
            vim.cmd("colorscheme catppuccin")
        end
    }

    -- Lua
    use { "ahmedkhalf/project.nvim" }
    use {
        "nvim-neorg/neorg",
        requires = "nvim-lua/plenary.nvim",
        cmd = "Neorg",
        config = function()
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
        end
    }

    use { 'ggandor/lightspeed.nvim' }
    use { 'ThePrimeagen/harpoon' }
    use {
        "MunifTanjim/nui.nvim",
        cmd = "Neotree",
    }
    use {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v2.x",
        requires = {
            "nvim-lua/plenary.nvim",
            "kyazdani42/nvim-web-devicons", -- not strictly required, but recommended
        },
        after = {
            "nui.nvim",
        },
        config = function()
            vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])
            require("neo-tree").setup({
                source_selector = {
                    winbar = false,
                    statusline = false
                }
            })
        end,
    }
    use { 'lewis6991/impatient.nvim' }
    ------------------------------------------------------------------------------------------
    -- this will manage all external LSP/code formatters etc
    require 'nvim-web-devicons'.setup({
        -- globally enable default icons (default to false)
        -- will get overriden by `get_icons` option
        default = true;
    })
    -----------------------------------------------
    require("project_nvim").setup({
        show_hidden = true,
        manual_mode = true,
    })
    require("config.nvim-cmp")
    require("nvim-treesitter.configs").setup({
        -- A list of parser names, or "all"
        ensure_installed = { "python", "lua", "norg" },
        highlight = { -- Be sure to enable highlights if you haven't!
            enable = true,
        },
        indent = {
            enable = true
        },
        incremental_selection = {
            enable = true,
            keymaps = {
                init_selection = "gnn",
                node_incremental = "grn",
                scope_incremental = "grc",
                node_decremental = "grm",
            },
        },

        -- Install parsers synchronously (only applied to `ensure_installed`)
        sync_install = false,

        -- Automatically install missing parsers when entering buffer
        auto_install = true,
    })
    -- Automatically set up your configuration after cloning packer.nvim
end)
