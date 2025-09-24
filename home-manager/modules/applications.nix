{ inputs, lib, config, pkgs, ... }: {

  home.packages = with pkgs; [
    obsidian
    # discord
    dbeaver-bin
    libreoffice-qt
    zotero_7
    distrobox
  ];

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

  systemd.user.services.obsidian = {
    enable = true;
    content = ''
            [Unit]
            Description=Start Obsidian at login
            After=graphical-session.target

            [Service]
            Type=simple
            ExecStart=${pkgs.obsidian}/bin/obsidian
            Restart=on-failure
            Environment=DISPLAY=:0
            Environment=XAUTHORITY=%h/.Xauthority

            [Install]
            WantedBy=default.target
      		'';
  };

}
