{ inputs, lib, config, pkgs, ... }: {

  imports = [ ../../common-darwin.nix ];

  # https://discourse.nixos.org/t/documentation-on-how-the-http-s-binary-cache-api-works/10432
  # testing nix cache, first find the hash of a package `/nix/store/{hash}-pkg.1.2.3`
  # `curl localhost:8123/hash.narinfo` to get the narinfo of the package
  # `tail -f /tmp/nginx/access.log` see hits/misses once i curl 
  # once i get the narinfo, i can download the package from the url in the output:
  # `wget localhost:8123/nar/{hash}.nar.xz`

  nix.settings.substituters = [ "http://localhost:8123?priority=10" ];

  environment.systemPackages = with pkgs; [ nginx ];

  # this runs a persistent vm btw https://nixcademy.com/posts/macos-linux-builder/
  # to ssh: 
  # https://github.com/LnL7/nix-darwin/blob/678b22642abde2ee77ae2218ab41d802f010e5b0/modules/nix/linux-builder.nix#L215

  nix.linux-builder = {
    config = {
      nix.settings.substituters = [ "http://192.168.68.57:8123?priority=1" ];
    };
    enable = true;
    ephemeral = true;
    maxJobs = 4;
    config = {
      virtualisation = {
        darwin-builder = {
          diskSize = 40 * 1024;
          memorySize = 8 * 1024;
        };
        cores = 6;
      };
    };
  };

  launchd.user.agents.nginx = {
    command =
      "${pkgs.nginx}/bin/nginx -c config/nginx-cache/nginx-server.conf -e /Users/ludvi/.local/state/nginx-cache/error.log";
    serviceConfig = {
      KeepAlive = true;
      RunAtLoad = true;
      UserName =
        "ludvi"; # needed cuz SIP prevents accessing certain folders, it aborts with SIGABRT
    };
  };

  system.stateVersion = 5;
}
