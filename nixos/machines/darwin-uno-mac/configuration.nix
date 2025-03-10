{ inputs, lib, config, pkgs, ... }: {

  imports = [
    ../../common-darwin.nix
    inputs.nix-rosetta-builder.darwinModules.default
  ];

  # https://discourse.nixos.org/t/documentation-on-how-the-http-s-binary-cache-api-works/10432
  # testing nix cache, first find the hash of a package `/nix/store/{hash}-pkg.1.2.3`
  # `curl localhost:8123/hash.narinfo` to get the narinfo of the package
  # `tail -f /tmp/nginx/access.log` see hits/misses once i curl 
  # once i get the narinfo, i can download the package from the url in the output:
  # `wget localhost:8123/nar/{hash}.nar.xz`

  nix.settings.substituters =
    lib.mkAfter [ "http://localhost:8123?priority=10" ];
  nix.settings.download-buffer-size = 100000000;

  environment.systemPackages = with pkgs; [ nginx ollama caddy ];

  # this runs a persistent vm btw https://nixcademy.com/posts/macos-linux-builder/
  # to ssh: 
  # https://github.com/LnL7/nix-darwin/blob/678b22642abde2ee77ae2218ab41d802f010e5b0/modules/nix/linux-builder.nix#L215

  # nix.linux-builder = {
  #   config = {
  #     nix.settings.substituters = [ "http://192.168.68.57:8123?priority=1" ];
  #   };
  #   enable = true;
  #   ephemeral = true;
  #   maxJobs = 4;
  #   config = {
  #     virtualisation = {
  #       darwin-builder = {
  #         diskSize = 40 * 1024;
  #         memorySize = 8 * 1024;
  #       };
  #       cores = 6;
  #     };
  #   };
  # };

  nix-rosetta-builder.onDemand = true;
  nix-rosetta-builder.extraConfig = {
    nix.settings.substituters =
      lib.mkAfter [ "http://192.168.68.57:8123?priority=1" ];
    nix.settings.download-buffer-size = 100000000;
  };
  system.activationScripts.postActivation.text = ''
        # Create directory if it doesn't exist
        mkdir -p /tmp/nginx
        # You can also set permissions if needed
    		chown -R ludvi:wheel /tmp/nginx
  '';

  services.dnsmasq = {
    enable = true;
    addresses = { thinkcenter = "192.168.68.69"; };
    bind = "0.0.0.0";
  };

  # launchd.daemons.dnsmasq = {
  #   serviceConfig = {
  #     ProgramArguments = [
  #       "${pkgs.dnsmasq}/bin/dnsmasq"
  #       "--conf-file=${inputs.self}/config/dnsmasq/dnsmasq.conf"
  #       "--keep-in-foreground"
  #     ];
  #     KeepAlive = true;
  #     RunAtLoad = true;
  #     StandardErrorPath = "/tmp/dnsmasq_servic_err.log";
  #     StandardOutPath = "/tmp/dnsmasq_service.log";
  #   };
  # };
  #
  networking = {

    dns = [ "127.0.0.1" "8.8.8.8" ];
    knownNetworkServices =
      [ "Thunderbolt Bridge" "Ethernet" "USB 10/100/1000 LAN" "Wi-Fi" ];

  };

  launchd.user.agents.nginx = {
    command =
      "${pkgs.nginx}/bin/nginx -c ${inputs.self}/config/nginx-cache/nginx-server.conf -e /tmp/nginx/error_e.log";
    serviceConfig = {
      StandardErrorPath = "/tmp/nginx_service_err.log";
      KeepAlive = true;
      RunAtLoad = true;
      UserName =
        "ludvi"; # needed cuz SIP prevents accessing certain folders, it aborts with SIGABRT
    };
  };

  system.stateVersion = 5;
}
