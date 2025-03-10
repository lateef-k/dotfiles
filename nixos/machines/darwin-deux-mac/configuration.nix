{ inputs, lib, config, pkgs, ... }: {

  imports = [ ../../common-darwin.nix ];

  environment.systemPackages = with pkgs; [ nginx ];

  nix.settings.substituters =
    lib.mkAfter [ "http://localhost:8444?priority=10" ];

  system.activationScripts.postActivation.text = ''
        # Create directory if it doesn't exist
        mkdir -p /tmp/nginx
        # You can also set permissions if needed
    		chown -R ludvi:wheel /tmp/nginx
  '';

  networking = {
    dns = [ "192.168.68.57" "8.8.8.8" ];
    search = [ "home" ];
    knownNetworkServices =
      [ "Thunderbolt Bridge" "Ethernet" "USB 10/100/1000 LAN" "Wi-Fi" ];

  };
  launchd.user.agents.nginx = {
    command =
      "${pkgs.nginx}/bin/nginx -c ${inputs.self}/config/nginx-cache/nginx-client-darwin.conf -e /tmp/nginx_error_e.log";
    serviceConfig = {
      StandardErrorPath = "/tmp/nginx_service_err_e.log";
      KeepAlive = true;
      RunAtLoad = true;
      UserName =
        "ludvi"; # needed cuz SIP prevents accessing certain folders, it aborts with SIGABRT
    };
  };
  system.stateVersion = 5;
}
