{ inputs, lib, config, pkgs, system, ... }:

with lib; # Make lib functions available
let
  # Determine the platform based on builtins.currentSystem
  # This does *not* depend on the 'pkgs' module argument and avoids the cycle.
  isDarwin = lib.strings.hasSuffix "darwin" system;
  isLinux = lib.strings.hasSuffix "linux" system;

in {
  # Platform-specific configurations using mkMerge and optionalAttrs
  config = mkMerge [

    # Common attribute
    {
      nix.settings.substituters =
        mkBefore [ "http://localhost:8444?priority=10" ];
    }

    # Darwin-specific configuration
    (optionalAttrs isDarwin { # Use the flag derived from builtins.currentSystem
      system.activationScripts.postActivation.text = ''
        # Create directory if it doesn't exist
        mkdir -p /tmp/nginx
        # You can also set permissions if needed
        chown -R ludvi:wheel /tmp/nginx
      '';

      launchd.user.agents.nginx = {
        command =
          # Using the 'pkgs' argument *here* is fine because this value
          # is evaluated *after* the module structure is resolved and
          # the final 'pkgs' is available.
          "${pkgs.nginx}/bin/nginx -c ${inputs.self}/config/nginx-cache/nginx-client-darwin.conf -e /tmp/nginx_error_e.log";
        serviceConfig = {
          StandardErrorPath = "/tmp/nginx_service_err_e.log";
          KeepAlive = true;
          RunAtLoad = true;
          UserName = "ludvi";
        };
      };
    })

    # Linux-specific configuration
    (optionalAttrs isLinux { # Use the flag derived from builtins.currentSystem
      services.nginx = {
        enable = true;
        # Reading files is also fine
        config = builtins.readFile
          (inputs.self + /config/nginx-cache/nginx-client-linux.conf);
        # You might still need pkgs inside here later, which is okay:
        # package = pkgs.nginx; # Example
      };
    })
  ];
}
