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

        { "<leader>sR", false },
        { "<leader>r", "<cmd>Telescope resume<cr>", desc = "Resume" },
        { "<leader>t", "<cmd>Telescope<cr>", desc = "Resume" },
      },
      opts = function(_, opts)
        local Util = require("lazyvim.util")
        local action_state = require("telescope.actions.state")
        local telescope_actions = require("telescope.actions")

        local find_files_no_ignore = function(...)
          local line = action_state.get_current_line()
          Util.telescope("find_files", { no_ignore = true, default_text = line })()
        end

        local find_files_hidden = function(...)
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

        return opts
      end,
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
    opts = function(_, opts)
      require("luasnip.loaders.from_snipmate").lazy_load() -- looks for snippets/ in rtp
      require("luasnip.loaders.from_lua").lazy_load()
    end,
  },
}
