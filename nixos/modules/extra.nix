{ config, pkgs, lib, inputs, ... }:

let cfg = config.sys-extra;
in {

  options.sys-extra = { docker.enable = lib.mkEnableOption "Enable docker"; };

  config = lib.mkMerge [
    (lib.mkIf cfg.docker.enable {
      # ----------------------- DOCKER  -----------------------------

      environment.systemPackages = with pkgs; [ docker ];

      virtualisation.docker = {
        enable = true;
        liveRestore =
          false; # false so swarm works. when enabled, container survive even if daemon dies
        # daemon.setings.data-root = "/some-place/to-store-the-docker-data";
        daemon.settings = { insecure-registries = [ "192.168.8.0/24" ]; };
      };

      users.users.ludvi = {
        isNormalUser = true;
        extraGroups = [ "wheel" "docker" ];
      };

    })

    # ------------ TEST -------------
    {
      environment.systemPackages = [
        (pkgs.writeShellScriptBin "my-script" ''
          #!${pkgs.bash}/bin/bash
          echo "Hello from script!"
        '')
      ];
    }

  ];

}

