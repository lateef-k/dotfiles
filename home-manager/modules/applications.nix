{ inputs, lib, config, pkgs, ... }: {

  home.packages = with pkgs; [ obsidian discord ];

  # TODO: change into nightly 
  programs.firefox.enable = true;
  programs.chromium.enable = true;
  programs.kitty = {
    enable = true;
    extraConfig = ''
            hide_window_decorations yes;
      			shell ${pkgs.fish}/bin/fish
            	'';
    shellIntegration.mode = "";
  };
}
