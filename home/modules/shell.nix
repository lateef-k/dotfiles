{ inputs, lib, config, pkgs, ... }:

let
  cfg = config.bundle.shell;
  isLinux = lib.strings.hasSuffix "linux" builtins.currentSystem;

in {

  options.bundle.shell = {
    enable = lib.mkEnableOption "Enable ludvi's shell environment";
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      home.packages =
        (with pkgs; [ ncdu gh nerd-fonts.iosevka uv lazygit jq tree ])
        ++ (with pkgs.python312Packages; [ llm ]);

      programs.readline = {
        enable = true;
        extraConfig = lib.strings.fileContents "${inputs.self}/config/inputrc";
      };

      programs.starship = {
        enable = true;
        enableFishIntegration = true;
      };

      xdg.configFile = {
        "starship.toml".source = config.lib.file.mkOutOfStoreSymlink
          "${inputs.self}/config/starship.toml";
      };

      programs.zoxide = {
        enable = true;
        enableFishIntegration = true;
      };
    }

    # Conditionally include this if linux
    (lib.optionalAttrs isLinux { home.packages = (with pkgs; [ xclip iw ]); })
  ]);
}
