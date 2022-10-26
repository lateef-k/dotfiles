vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    -- Packer can manage itself
    use { 'wbthomason/packer.nvim', opt = true }
    use { 'christoomey/vim-tmux-navigator' }
    -- repeats whole commands, not just last component of command
    -- try ys_{ then . wethnet this, won't work properly
    use { 'tpope/vim-surround', keys = {
        { "n", "y" }, { "x", "g" }, { "n", "d" }, { "n", "c" }
    } }
    use { 'tpope/vim-repeat' }
    use { 'lukas-reineke/indent-blankline.nvim', config = function()
        require('indent_blankline').setup {
            filetype_exclude = { 'neo-tree' }
        }
    end
    }
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
                -- need require inside or will fail
                socket_name = require("utils").split(os.getenv("TMUX"), ",")[1],
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
        module = "luasnip",
        config = function()
            require("luasnip.loaders.from_snipmate").lazy_load()
        end
    }


    -- this sequencing is for mason-lspconfig
    use {
        'williamboman/mason.nvim',
        ft = {"lua", "python", "sh", "json"},
        cmd = {
            "Mason", "MasonInstall", "MasonUninstall", "MasonUninstallAll", "MasonLog",
            "LspInstall", "LspUninstall", --mason-lspconfig commands
            "LspLog", "LspInfo", "LspStart", "LspStop", "LspRestart" --lspconfig commands
        },
        config = function()
            require("mason").setup()
        end,
    }
    use {
        'williamboman/mason-lspconfig.nvim',
        after = "mason.nvim",
        config = function()
            require("mason-lspconfig").setup()
        end
    }
    use {
        'neovim/nvim-lspconfig',
        after = "mason-lspconfig.nvim",
        config = function()
            require("lspsetup")
        end
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
        requires = {
            { 'nvim-lua/plenary.nvim' }, { 'kyazdani42/nvim-web-devicons' },
            { "ahmedkhalf/project.nvim",
                opt = true,
                module = "project_nvim",
                config = function()
                    require("project_nvim").setup({
                        show_hidden = true,
                        manual_mode = true,
                    })
                end
            },
            use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make', }
        },
        cmd = "Telescope",
        module = "telescope", -- require telescope runs before command
        after = { "telescope-fzf-native.nvim", "project.nvim" },
        config = function()
            require("config.telescope")
        end

    }

    use { "folke/neodev.nvim",
        module = "neodev"
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
    use { 'ggandor/leap.nvim' }
    use {
        "MunifTanjim/nui.nvim",
        cmd = "Neotree",
    }
    use {
        "~/Documents/Forks/neo-tree.nvim",
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
                },
                window = {
                    position = "left",
                    width = 30,
                },
                filesystem = {
                    follow_current_file = true,
                    use_libuv_file_watcher = true,
                }
            })
        end,
    }
    -- :help conjure-mappings, uses localmapleader which i set to \
    use { 'Olical/conjure',
        event = "LspAttach",
        config = function()
            vim.api.nvim_exec([[ let g:conjure#mapping#doc_word = ""]], false)
        end
    }

    use { 'lewis6991/impatient.nvim' }
    use { 'tpope/vim-commentary' }
    ------------------------------------------------------------------------------------------
    require 'nvim-web-devicons'.setup({
        -- globally enable default icons (default to false)
        -- will get overriden by `get_icons` option
        default = true;
    })
    -----------------------------------------------
    require("config.nvim-cmp")
    require("nvim-treesitter.configs").setup({
        -- A list of parser names, or "all"
        ensure_installed = { "python", "lua", "norg" },
        highlight = { -- Be sure to enable highlights if you haven't!
            enable = true,
        },
        indent = {
            enable = true,
            disable = { "python" }
        },
        incremental_selection = {
            enable = true,
            keymaps = require("mappings").nvim_treesitter.incremental_selection.keymaps
            ,
        },

        -- Install parsers synchronously (only applied to `ensure_installed`)
        sync_install = false,

        -- Automatically install missing parsers when entering buffer
        auto_install = true,
    })
    -- Automatically set up your configuration after cloning packer.nvim
    --

    -- Lua
    use {
        "nvim-neorg/neorg",
        requires = "nvim-lua/plenary.nvim",
        cmd = "Neorg",
        ft = "norg",
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
                         close_split_on_jump = true
                    },
                    ["core.norg.concealer"] = {
                    }
                }
            }
        end
    }

   ---- most useful plugin, can run for specific file with `:StartupTime -- file.ext`
   use {
    "tweekmonster/startuptime.vim"
    } 
end)
