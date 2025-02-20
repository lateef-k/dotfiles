{ inputs, lib, config, pkgs, rootPath, ... }: {

  imports = [ ../../common-darwin.nix ];

  # https://discourse.nixos.org/t/documentation-on-how-the-http-s-binary-cache-api-works/10432
  # testing nix cache, first find the hash of a package `/nix/store/{hash}-pkg.1.2.3`
  # `curl localhost:8123/hash.narinfo` to get the narinfo of the package
  # `tail -f /tmp/nginx/access.log` see hits/misses once i curl 
  # once i get the narinfo, i can download the package from the url in the output:
  # `wget localhost:8123/nar/{hash}.nar.xz`

  nix.settings.substituters = [ "http://localhost:8123?priority=10" ];

  launchd.user.agents.nginx = {
    command =
      "${pkgs.nginx}/bin/nginx -c ${rootPath}/config/nginx-cache/nginx-server.conf -e /Users/ludvi/.local/state/nginx-cache/error.log";
    serviceConfig = {
      KeepAlive = true;
      RunAtLoad = true;
      UserName =
        "ludvi"; # needed cuz SIP prevents accessing certain folders, it aborts with SIGABRT
    };
  };

  system.stateVersion = 5;
}
