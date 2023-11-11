local disable = {
  "folke/noice.nvim",
  "nvim-pack/nvim-spectre",
  "RRethy/vim-illuminate",
  "folke/trouble.nvim",
  "folke/todo-comments.nvim",
  "folke/neoconf.nvim",
  "rcarriga/nvim-notify",
  "goolord/alpha-nvim",
  "folke/flash.nvim",
  -- "nvim-neo-tree/neo-tree.nvim",
  "zbirenbaum/copilot-cmp",
  "nvimdev/dashboard-nvim",
}

local disabled_plugins = {}

for _, plugin in ipairs(disable) do
  table.insert(disabled_plugins, {
    plugin,
    enabled = false,
  })
end

return {
  {
    "folke/flash.nvim",
    enabled = true,
    -- only using for the / improvement
    keys = {
      { "s", mode = { "n", "x", "o" }, false },
      { "S", mode = { "n", "o", "x" }, false },
    },
  },
  {
    "zbirenbaum/copilot.lua",
    opts = {
      suggestion = {
        enabled = true,
        auto_trigger = false,
        keymap = {
          accept = "<M-CR>",
          accept_word = false,
          accept_line = false,
          next = "<M-]>",
          prev = "<M-[>",
          dismiss = "<M-c>",
        },
      },
    },
  },
  {
    "echasnovski/mini.pairs",
    opts = { mappings = {
      ["'"] = false,
      ['"'] = false,
    } },
  },
  {
    "echasnovski/mini.surround",
    opts = {
      mappings = {
        add = "sa", -- Add surrounding in Normal and Visual modes
        delete = "sd", -- Delete surrounding
        find = "sf", -- Find surrounding (to the right)
        find_left = "sF", -- Find surrounding (to the left)
        highlight = "sh", -- Highlight surrounding
        replace = "sr", -- Replace surrounding
        update_n_lines = "sn", -- Update `n_lines`

        suffix_last = "l", -- Suffix to search with "prev" method
        suffix_next = "n", -- Suffix to search with "next" method
      },
    },
  },
  {
    "echasnovski/mini.indentscope",
    opts = {
      draw = {
        delay = 0,
        animation = require("mini.indentscope").gen_animation.none(),
      },
    },
  },
  {
    "echasnovski/mini.ai",
    opts = function(_, opts)
      local ai = require("mini.ai")
      opts.search_method = "cover_or_nearest"
      opts.custom_textobjects.c = ai.gen_spec.treesitter({
        a = { "@call.outer" },
        i = { "@call.inner" },
      })
      opts.custom_textobjects.C = ai.gen_spec.treesitter({
        a = { "@class.outer" },
        i = { "@class.inner" },
      })
      return opts
    end,
  },
  {
    {
      "nvim-telescope/telescope.nvim",
      keys = {
        { "<leader><leader>", "<Cmd>Telescope frecency workspace=CWD<CR>" },
        { "<leader>sR", false },
        { "<leader>r", "<cmd>Telescope resume<cr>", desc = "Resume" },
        { "<leader>t", "<cmd>Telescope<cr>", desc = "Resume" },
      },
      opts = function(_, opts)
        local Util = require("lazyvim.util")
        local action_state = require("telescope.actions.state")
        local telescope_actions = require("telescope.actions")

        local find_files_no_ignore = function()
          local line = action_state.get_current_line()
          Util.telescope("find_files", { no_ignore = true, default_text = line })()
        end

        local find_files_hidden = function()
          local line = action_state.get_current_line()
          Util.telescope("find_files", { hidden = true, default_text = line })()
        end

        local cycle_history_next = function(...)
          return telescope_actions.cycle_history_next(...)
        end

        local cycle_history_prev = function(...)
          return telescope_actions.cycle_history_prev(...)
        end

        local preview_scrolling_down = function(...)
          return telescope_actions.preview_scrolling_down(...)
        end

        local preview_scrolling_up = function(...)
          return telescope_actions.preview_scrolling_up(...)
        end

        local close_telescope = function(...)
          return telescope_actions.close(...)
        end

        opts.defaults.mappings = {
          i = {
            ["<a-i>"] = find_files_no_ignore,
            ["<a-h>"] = find_files_hidden,
            ["<C-Down>"] = cycle_history_next,
            ["<C-Up>"] = cycle_history_prev,
            ["<C-f>"] = preview_scrolling_down,
            ["<C-b>"] = preview_scrolling_up,
          },
          n = {
            ["q"] = close_telescope,
          },
        }

        opts.defaults.file_ignore_patterns = {
          ".venv",
        }
        --
        -- opts.extensions = {
        --   frecency = {
        --
        --   }
        -- }

        return opts
      end,
      dependencies = {
        {
          "nvim-telescope/telescope-frecency.nvim",
          config = function()
            require("telescope").load_extension("frecency")
          end,
        },
      },
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      local CodeGPTModule = require("codegpt")
      opts.sections.lualine_x = { CodeGPTModule.get_status, "encoding", "fileformat" }
    end,
  },
  {
    "L3MON4D3/LuaSnip",
    event = "InsertEnter",
    opts = function(_, _)
      require("luasnip.loaders.from_snipmate").lazy_load() -- looks for snippets/ in rtp
      require("luasnip.loaders.from_lua").lazy_load()
    end,
  },
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        ["python"] = { "isort", "black" },
      },
    },
  },
  {
    "alexghergh/nvim-tmux-navigation",
    config = true,
    event = "VeryLazy",
  },

  { "nvim-treesitter/nvim-treesitter-context", event = "VeryLazy" },

  { "tpope/vim-fugitive", cmd = "Git" },

  {
    "mbbill/undotree",
    event = "VeryLazy",
    keys = {
      { "<leader>uu", "<cmd>UndotreeToggle<CR>", { noremap = true, silent = true, desc = "Toggle undotree" } },
    },
  },

  {
    "epwalsh/obsidian.nvim",
    dependencies = {
      -- Required.
      "nvim-lua/plenary.nvim",
      -- see below for full list of optional dependencies 👇
    },
    cmd = {
      "ObsidianOpen",
      "ObsidianNew",
      "ObsidianQuickSwitch",
      "ObsidianFollowLink",
      "ObsidianBacklinks",
      "ObsidianToday",
      "ObsidianYesterday",
      "ObsidianTemplate",
      "ObsidianSearch",
      "ObsidianLink",
      "ObsidianLinkNew",
    },
    keys = {
      {
        "<leader>nn",
        function()
          local commands = {
            "ObsidianOpen",
            "ObsidianNew",
            "ObsidianQuickSwitch",
            "ObsidianFollowLink",
            "ObsidianBacklinks",
            "ObsidianToday",
            "ObsidianYesterday",
            "ObsidianTemplate",
            "ObsidianSearch",
            "ObsidianLenk",
            "ObsidianLinkNew",
          }

          vim.ui.select(commands, {}, function(cmd)
            if cmd ~= nil then
              vim.cmd(":" .. cmd)
            end
          end)
        end,
        { noremap = true, silent = true, desc = "Obsidian commands" },
      },
      { "<leader>no", "<cmd>ObsidianOpen<CR><Esc>", { noremap = true, silent = true, desc = "Open in Obsidian" } },
      {
        "<leader>ne",
        "<cmd>ObsidianNew<CR><Esc>",
        { noremap = true, silent = true, desc = "Create new note in Obsidian" },
      },
      {
        "<leader>nf",
        "<cmd>ObsidianQuickSwitch<CR><Esc>",
        { noremap = true, silent = true, desc = "Quick switch in Obsidian" },
      },
      {
        "gf",
        function()
          if require("obsidian").util.cursor_on_markdown_link() then
            return "<cmd>ObsidianFollowLink<CR>"
          else
            return "gf"
          end
        end,
        { noremap = true, silent = true, desc = "Follow link in Obsidian" },
      },
      {
        "<leader>nb",
        "<cmd>ObsidianBacklinks<CR><Esc>",
        { noremap = true, silent = true, desc = "Show backlinks in Obsidian", buffer = true },
      },
      {
        "<leader>nt",
        "<cmd>ObsidianToday<CR><Esc>",
        { noremap = true, silent = true, desc = "Go to today's note in Obsidian" },
      },
      {
        "<leader>nt",
        "<cmd>ObsidianTemplate<CR><Esc>",
        { noremap = true, silent = true, desc = "Insert Obsidian template" },
      },
      {
        "<leader>sn",
        "<cmd>ObsidianSearch<CR><Esc>",
        { noremap = true, silent = true, desc = "Search in Obsidian" },
      },
      {
        "<leader>nl",
        "<cmd>ObsidianLink<CR><Esc>",
        { noremap = true, silent = true, desc = "Create Obsidian link" },
      },
      {
        "<leader>nx",
        "<cmd>ObsidianLinkNew<CR><Esc>",
        { noremap = true, silent = true, desc = "Create new Obsidian link" },
      },
    },
    opts = {
      dir = os.getenv("OBSIDIAN_HOME"), -- no need to call 'vim.fn.expand' here
      -- see below for full list of options 👇
      daily_notes = {
        -- Optional, if you keep daily notes in a separate directory.
        folder = "Journal/Computer",
        -- Optional, if you want to change the date format for the ID of daily notes.
        date_format = "%Y-%m-%d",
        -- Optional, if you want to change the date format of the default alias of daily notes.
        alias_format = "%B %-d, %Y",
      },
      overwrite_mappings = false,
      mappings = {},
    },
  },

  {
    "stevearc/dressing.nvim",
    opts = {},
  },
  {
    "stevearc/oil.nvim",
    opts = {
      delete_to_trash = true,
    },
    cmd = "Oil",
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },
  {
    "dpayne/CodeGPT.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
    },
    cmd = "Chat",
    keys = {
      { "ai" },
    },
    config = function()
      require("codegpt.config")
    end,
  },
  {
    "chomosuke/term-edit.nvim",
    event = "TermEnter",
    opts = {
      prompt_end = "> ",
    },
    version = "1.*",
  },
  {
    "willothy/flatten.nvim",
    config = true,
    -- or pass configuration with
    -- opts = {  }
    -- Ensure that it runs first to minimize delay when opening file from terminal
    lazy = false,
    priority = 1001,
  },
  unpack(disabled_plugins),
}
