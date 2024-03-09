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
  "nvim-telescope/telescope.nvim",
  "folke/flash.nvim",
  "echasnovski/mini.pairs",
}

local disabled_plugins = {}

--

for _, plugin in ipairs(disable) do
  table.insert(disabled_plugins, {
    plugin,
    enabled = false,
  })
end

local cmd = vim.api.nvim_create_user_command

return {
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
  -- {
  --   "echasnovski/mini.pairs",
  --   opts = { mappings = {
  --     ["'"] = false,
  --     ['"'] = false,
  --   } },
  -- },
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
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      local CodeGPTModule = require("codegpt")
      opts.sections.lualine_x = { CodeGPTModule.get_status, "encoding", "fileformat" }
    end,
  },
  {
    "L3MON4D3/LuaSnip",
    event = "InsertEnter",
    config = function()
      require("luasnip").setup({
        enable_autosnippets = true,
      })
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
      { "<leader>no", "<cmd>ObsidianOpen<CR><Esc>", { noremap = true, silent = true, desc = "Open in Obsidian" } },
      {
        "<leader>ne",
        "<cmd>ObsidianNew<CR><Esc>",
        { noremap = true, silent = true, desc = "Create new note in Obsidian" },
      },
      {
        "<leader>n<leader>",
        "<cmd>ObsidianQuickSwitch<CR><Esc>",
        { noremap = true, silent = true, desc = "Quick switch in Obsidian" },
      },
      {
        "<leader>n/",
        "<cmd>ObsidianSearch<CR><Esc>",
        { noremap = true, silent = true, desc = "Search in Obsidian" },
      },
      {
        "<leader>nb",
        "<cmd>ObsidianBacklinks<CR><Esc>",
        { noremap = true, silent = true, desc = "Show backlinks in Obsidian", buffer = true },
      },
      {
        "<leader>nn",
        "<cmd>ObsidianToday<CR><Esc>",
        { noremap = true, silent = true, desc = "Go to today's note in Obsidian" },
      },
      {
        "<leader>nt",
        "<cmd>ObsidianTemplate<CR><Esc>",
        { noremap = true, silent = true, desc = "Insert Obsidian template" },
      },
      {
        mode = { "n", "v" },
        "<leader>nx",
        "<cmd>ObsidianLinkNew<CR><Esc>",
        { noremap = true, silent = true, desc = "Create new Obsidian link" },
      },
      {
        mode = { "n", "v" },
        "<leader>nl",
        "<cmd>ObsidianLink<CR><Esc>",
        { noremap = true, silent = true, desc = "Create Obsidian link" },
      },
    },
    opts = {
      dir = os.getenv("OBSIDIAN_HOME"), -- no need to call 'vim.fn.expand' here
      -- see below for full list of options 👇
      daily_notes = {
        -- Optional, if you keep daily notes in a separate directory.
        folder = "Journal",
        -- Optional, if you want to change the date format for the ID of daily notes.
        date_format = "%Y-%m-%d",
        -- Optional, if you want to change the date format of the default alias of daily notes.
        alias_format = "%B %-d, %Y",
      },
      mappings = {
        ["gf"] = {
          action = function()
            require("obsidian").utill.gf_passthrough()
          end,
        },
      },
    },
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
    "lukas-reineke/headlines.nvim",
    dependencies = "nvim-treesitter/nvim-treesitter",
    config = true, -- or `opts = {}`
    ft = "markdown",
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- pyright will be automatically installed with mason and loaded with lspconfig
        marksman = false,
        awk_ls = {},
        bashls = {},
      },
    },
    init = function()
      local keys = require("lazyvim.plugins.lsp.keymaps").get()
      -- disable a keymap
      keys[#keys + 1] = { "gd", false }
      keys[#keys + 1] = { "gr", false }
      keys[#keys + 1] = { "gy", false }
      keys[#keys + 1] = { "gI", false }
    end,
  },
  {
    "ibhagwan/fzf-lua",
    -- optional for icon support
    dependencies = { "nvim-tree/nvim-web-devicons" },
    init = function()
      cmd("FilesCwd", function()
        require("fzf-lua").files({ cwd = vim.fn.getcwd() })
        vim.api.nvim_feedkeys("IHello", "n", false)
      end, {})
    end,
    opts = {
      "fzf-tmux", -- :help fzf-lua-profiles
    },
    keys = {
      { "<leader>p", "<cmd>lua require('fzf-lua').commands()<cr>", desc = "Commands" },
      { "<leader>/", "<cmd>lua require('fzf-lua').grep({ search = '' })<cr>", desc = "Grep (root dir)" },
      { "<leader><space>", "<cmd>lua require('fzf-lua').files()<cr>", desc = "Find Files (root dir)" },
      { "<leader>b", "<cmd>lua require('fzf-lua').buffers()<cr>", desc = "Switch Buffer" },
      { "<leader>j", "<cmd>lua require('fzf-lua').jumps()<cr>", desc = "Jumps" },
      { "<leader>?", "<cmd>lua require('fzf-lua').builtin()<cr>", desc = "FzfLua" },
      { "<leader>'", "<cmd>lua require('fzf-lua').resume()<cr>", desc = "FzfLua" },
      -- TODO: move this to on_attach
      {
        "<leader>s",
        function()
          require("fzf-lua").lsp_document_symbols({ lsp_symbols = require("lazyvim.config").get_kind_filter() })
        end,
        desc = "Goto Symbol",
      },
      {
        "<leader>S",
        function()
          require("fzf-lua").lsp_workspace_symbols({ lsp_symbols = require("lazyvim.config").get_kind_filter() })
        end,
        desc = "Goto Symbol (Workspace)",
      },
      { "gr", "<cmd>lua require('fzf-lua').lsp_references()<cr>", desc = "References" },
      { "gI", "<cmd>lua require('fzf-lua').lsp_implementations()<cr>", desc = "Goto Implementation" },
      { "gd", "<cmd>lua require('fzf-lua').lsp_definitions()<cr>", desc = "Goto Definition" },
      { "gy", "<cmd>lua require('fzf-lua').lsp_typedefs()<cr>", desc = "Goto Type Definition" },
      { "<leader>d", "<cmd>lua require('fzf-lua').diagnostics({ bufnr = 0 })<cr>", desc = "Document diagnostics" },
      { "<leader>D", "<cmd>lua require('fzf-lua').diagnostics()<cr>", desc = "Workspace diagnostics" },
      {
        mode = { "n", "v", "i" },
        "<C-x><C-f>",
        function()
          require("fzf-lua").complete_path()
        end,
        { silent = true, desc = "Fuzzy complete path" },
      },
      {
        mode = { "n", "v", "i" },
        "<C-x><C-l>",
        function()
          require("fzf-lua").complete_line()
        end,
        { silent = true, desc = "Fuzzy complete path" },
      },

      -- -- TODO: make this work for LSPs
      -- {
      --   mode = { "n", "v", "i" },
      --   "<C-x><C-l>",
      --   function()
      --     local result, err = vim.lsp.buf_request_sync(
      --       vim.api.nvim_get_current_buf(),
      --       "textDocument/completion",
      --       vim.lsp.util.make_position_params(),
      --       1000
      --     )
      --     if err then
      --       print("Error fetching completions: ", err)
      --     else
      --       print("got it")
      --       print(vim.inspect(result))
      --       local buf = vim.api.nvim_get_current_buf()
      --       -- Process the result which contains the completion items
      --       -- Example: print the label of each completion item
      --       if result and result.items then
      --         for _, item in ipairs(result.items) do
      --           print(item.label)
      --         end
      --       end
      --     end
      --   end,
      --   { silent = true, desc = "Fuzzy complete path" },
      -- },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      indent = {
        disable = { "python" },
      },
    },
  },
  {
    "sourcegraph/sg.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim", --[[ "nvim-telescope/telescope.nvim ]]
    },
    -- keys = {
    --   {
    --     mode = { "n", "v" },
    --     "<leader>nx",
    --     "<cmd>ObsidianLinkNew<CR><Esc>",
    --     { noremap = true, silent = true, desc = "Create new Obsidian link" },
    --   },
    -- },
    config = true,
  },
  unpack(disabled_plugins),
}
