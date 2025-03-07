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

  launchd.user.agents.nginx = {
    command =
      "${pkgs.nginx}/bin/nginx -c ${inputs.self}/config/nginx-cache/nginx-client-darwin.conf -e /tmp/nginx/error_e.log";
    serviceConfig = {
      StandardErrorPath = "/tmp/nginx_service.log";
      KeepAlive = true;
      RunAtLoad = true;
      UserName =
        "ludvi"; # needed cuz SIP prevents accessing certain folders, it aborts with SIGABRT
    };
  };
  system.stateVersion = 5;
}
