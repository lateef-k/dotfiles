{ inputs, lib, config, pkgs, ... }: {

  imports = [
    ../../common-darwin.nix
    inputs.nix-rosetta-builder.darwinModules.default
  ];

  nix.settings = {
    substituters = lib.mkAfter [ "http://localhost:8123?priority=10" ];
    download-buffer-size = 100000000;
  };

  nix-rosetta-builder = {
    onDemand = true;
    extraConfig = {
      nix.settings.substituters =
        lib.mkAfter [ "http://192.168.68.57:8123?priority=1" ];
      nix.settings.download-buffer-size = 100000000;
    };
  };

  system.activationScripts.postActivation.text = ''
        # Create directory if it doesn't exist
        mkdir -p /tmp/nginx
        # You can also set permissions if needed
    		chown -R ludvi:wheel /tmp/nginx
  '';

  networking = {
    dns = [ "1.1.1.1" "1.0.0.1" ];
    knownNetworkServices =
      [ "Thunderbolt Bridge" "Ethernet" "USB 10/100/1000 LAN" "Wi-Fi" ];
  };

  launchd.user.agents.nginx = {
    serviceConfig = {
      ProgramArguments = [
        "${pkgs.nginx}/bin/nginx"
        "-c"
        "${inputs.self}/config/nginx-cache/nginx-server.conf"
        "-e"
        "/tmp/nginx/error_e.log"
      ];

      StandardErrorPath = "/tmp/nginx_service_err.log";
      KeepAlive = true;
      RunAtLoad = true;
      UserName =
        "ludvi"; # needed cuz SIP prevents accessing certain folders, it aborts with SIGABRT
    };
  };

  launchd.user.agents.ollama = {
    serviceConfig = {
      ProgramArguments = [ "${pkgs.ollama}/bin/ollama" "serve" ];
      EnvironmentVariables = { OLLAMA_HOST = "0.0.0.0"; };
      StandardErrorPath = "/tmp/ollama_service_err.log";
      StandardOutPath = "/tmp/ollama_service.log";
      KeepAlive = true;
      RunAtLoad = true;
      UserName =
        "ludvi"; # needed cuz SIP prevents accessing certain folders, it aborts with SIGABRT
    };
  };

  system.stateVersion = 5;
}
