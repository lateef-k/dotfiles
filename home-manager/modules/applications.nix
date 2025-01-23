{ inputs, lib, config, pkgs, ... }: {

  home.packages = with pkgs; [
    obsidian
    # discord
    dbeaver-bin
    libreoffice-qt
    zotero_7
    neovide
    distrobox
    inputs.ghostty.packages.x86_64-linux.default
  ];

  home.file.".config/ghostty/config" = {
    source = "${config.home.homeDirectory}/Dotfiles/config/ghostty";
    recursive = true;
  };

  programs.rofi = {
    enable = true;
    terminal = "${pkgs.kitty}/bin/kitty";
  };

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
    package = pkgs.vscode.fhs;
  };

  services.gnome-keyring = {
    enable = true;
    components =
      [ "pkcs11" "secrets" ]; # didnt include ssh cause i dont need it here
  };

}
