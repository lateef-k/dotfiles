{ inputs, lib, config, pkgs, ... }: {

  # FOR OPTIONS CONSULT: 
  # https://nix-community.github.io/nixvim/NeovimOptions/index.html

  imports = [ inputs.nixvim.homeManagerModules.nixvim ];

  nixpkgs.overlays = [ inputs.neovim-nightly-overlay.overlays.default ];

  programs.nixvim.enable = true;
  programs.nixvim.package =
    inputs.neovim-nightly-overlay.packages.${pkgs.system}.default;
  programs.nixvim.extraConfigLua = lib.strings.fileContents
    "${config.home.homeDirectory}/dotfiles/programs/neovim/config.lua";

  programs.nixvim = {

    colorschemes = {
      catppuccin = {
        enable = true;
        settings.flavour = "frappe";
      };
    };

    globals = { mapleader = " "; };

    opts = { grepprg = "rg --vimgrep --smart-case"; };

    autoCmd = [{
      event = "FileType";
      pattern = "nix";
      command = "setlocal tabstop=2 shiftwidth=2 softtabstop=2";
    }];

    keymaps = [
      {
        action = "<cmd>Neotree toggle<CR>";
        key = "<leader>ne";
      }
      {
        key = "]b";
        action = "<cmd>bnext<CR>";
      }
      {
        key = "[b";
        action = "<cmd>bprevious<CR>";
      }
      {
        key = "]c";
        action = "<cmd>cnext<CR>";
      }
      {
        key = "[c";
        action = "<cmd>cprevious<CR>";
      }
    ];

    plugins = {
      tmux-navigator.enable = true;
      cmp = {
        enable = true;
        settings = {
          snippet.expand =
            "function(args) require('luasnip').lsp_expand(args.body) end";
          mapping = {
            "<tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
            "<s-tab>" =
              "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
            "<cr>" = "cmp.mapping.confirm({ select = true })";
          };
          sources = [
            { name = "path"; }
            { name = "nvim_lsp"; }
            { name = "nvim_lsp_signature_help"; }
            { name = "nvim_lua"; }
            { name = "luasnip"; }
            {
              name = "buffer";
              option.get_bufnrs.__raw = "vim.api.nvim_list_bufs";
            }
          ];
          experimental.ghost_text = true;
        };
      };

      lsp = {
        enable = true;
        servers = {
          pyright.enable = true;
          nixd.enable = true;
          nil-ls.enable = true;
        };
        keymaps = {
          lspBuf = {
            K = "hover";
            gi = "implementation";
            gt = "type_definition";
            "<leader>cr" = "rename";
            "<leader>cf" = {
              action = "format";
              desc = "Format";
            };
            "<leader>ca" = {
              action = "code_action";
              desc = "Code Actions";
            };
          };
          diagnostic = {
            "[d" = {
              action = "goto_prev";
              desc = "Go to prev diagnostic";
            };
            "]d" = {
              action = "goto_next";
              desc = "Go to next diagnostic";
            };
          };
        };
      };
      fzf-lua = {
        enable = true;
        keymaps = {
          "<leader>b".action = "buffers";
          "<leader><leader>".action = "files";
          "<leader>?".action = "builtins";
          "<leader>s".action = "lsp_document_symbols";
          "<leader>S".action = "lsp_workspace_symbols";
          "<leader>/".action = "grep_project";
          "<leader>d".action = "diagnostics_document";
          "<leader>D".action = "diagnostics_workspace";
          "<leader>o".action = "oldfiles";
          "<leader>r".action = "resume";
          "<leader>j".action = "jumplist";
          "gr".action = "lsp_references";
          "gd".action = "lsp_definition";
        };
      };
      conform-nvim = {
        enable = true;
        formattersByFt = {
          "*" = [ "codespell" ];
          "_" = [ "trim_whitespace" ];
          lua = [ "stylua" ];
          nix = [ "nixfmt" ];
          python = [ "isort" "black" ];
          markdown = [ "mdformat" ];
        };
        formatOnSave = ''
            function(bufnr)
                -- Disable with a global or buffer-local variable
                if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          	return
                end
                return { timeout_ms = 500, lsp_fallback = true }
              end
        '';
      };

      mini = {
        enable = true;
        modules.ai = { search_method = "cover_or_nearest"; };
        modules.surround = { };
      };
      luasnip = {
        enable = true;
        fromVscode = [ { } ];
      };
      nvim-autopairs.enable = true;
      treesitter.enable = true;
      friendly-snippets.enable = true;
      which-key.enable = true;
      neo-tree.enable = true;
    };
  };
}
