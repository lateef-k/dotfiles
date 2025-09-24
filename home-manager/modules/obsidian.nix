{ inputs, lib, config, pkgs, ... }: {

  home.packages = with pkgs; [ obsidian ];

  systemd.user.services.obsidian = {
    Unit = {
      Description = "Start Obsidian at login to sync";
      After = [ "graphical-session.target" ];
      Requires = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.obsidian}/bin/obsidian";
      Restart = "on-failure";
      Environment = [ "DISPLAY=:0" "XAUTHORITY=%h/.Xauthority" ];
    };
    Install = { WantedBy = [ "graphical-session.target" ]; };
  };
}
