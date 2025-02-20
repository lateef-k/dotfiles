# home.nix
{ config, pkgs, lib, ... }:

{
  wayland.windowManager.sway = {
    enable = true;

    # Sway configuration
    config = {
      modifier = "Mod4"; # Windows/Super key

      # Default terminal
      terminal = "${pkgs.foot}/bin/foot";

      output = {
        "DP-2" = { mode = "3840x2160"; };
        "eDP-1" = { mode = "2048x1152"; };
      };

      # Basic key bindings
      keybindings =
        let modifier = config.wayland.windowManager.sway.config.modifier;
        in lib.mkOptionDefault {
          "${modifier}+Return" =
            "exec ${config.wayland.windowManager.sway.config.terminal}";
          "${modifier}+b" = "exec ${pkgs.firefox}/bin/firefox";
          "${modifier}+q" = "kill";
          "${modifier}+Shift+r" = "reload";
          "${modifier}+Shift+e" =
            "exec swaynag -t warning -m 'Exit sway?' -b 'Yes' 'swaymsg exit'";

          # Focus
          "${modifier}+Left" = "focus left";
          "${modifier}+Down" = "focus down";
          "${modifier}+Up" = "focus up";
          "${modifier}+Right" = "focus right";

          # Move
          "${modifier}+Shift+Left" = "move left";
          "${modifier}+Shift+Down" = "move down";
          "${modifier}+Shift+Up" = "move up";
          "${modifier}+Shift+Right" = "move right";
        };

      # Workspace configuration
      workspaceOutputAssign = [
        {
          workspace = "1";
          output = "eDP-1";
        }
        {
          workspace = "2";
          output = "eDP-1";
        }
      ];

      # Default programs
      startup = [ { command = "firefox"; } { command = "foot"; } ];

      # Appearance
      gaps = {
        inner = 5;
        outer = 3;
      };

      bars = [{
        position = "top";
        statusCommand = "${pkgs.i3status}/bin/i3status";

        colors = {
          background = "#323232";
          statusline = "#ffffff";
          focusedWorkspace = {
            background = "#285577";
            border = "#4c7899";
            text = "#ffffff";
          };
          activeWorkspace = {
            background = "#333333";
            border = "#333333";
            text = "#ffffff";
          };
          inactiveWorkspace = {
            background = "#323232";
            border = "#323232";
            text = "#888888";
          };
          urgentWorkspace = {
            background = "#900000";
            border = "#2f343a";
            text = "#ffffff";
          };
        };
      }];
    };
  };

  # Required packages
  home.packages = with pkgs; [ foot i3status ];
}
