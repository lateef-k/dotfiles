{ inputs, lib, config, pkgs, pkgs-unstable, ... }: {

  home.packages = with pkgs; [ obsidian discord dbeaver-bin libreoffice-qt ];

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
  programs.vscode = {
    enable = true;
    package = pkgs-unstable.vscode.fhs;
  };
}
