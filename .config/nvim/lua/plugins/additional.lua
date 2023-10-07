return {
  {
    "alexghergh/nvim-tmux-navigation",
    config = true,
    event = "VeryLazy",
  },

  { "nvim-treesitter/nvim-treesitter-context", event = "VeryLazy" },

  { "tpope/vim-fugitive", command = "Git" },

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
    opts = {},
    -- Optional dependencies
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },
}
