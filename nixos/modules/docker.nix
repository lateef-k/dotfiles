{ inputs, lib, config, pkgs, ... }: {
  environment.systemPackages = with pkgs; [ docker ];

  virtualisation.docker = {
    enable = true;
    liveRestore =
      false; # false so swarm works. when enabled, container survive even if daemon dies
    # daemon.setings.data-root = "/some-place/to-store-the-docker-data";
  };

  users.users.ludvi = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" ];
  };
}

