# orbstack-nixos-vm.nix
# Nix-darwin module to manage NixOS VMs in OrbStack
# Expects lib, pkgs (for aarch64-darwin), and self (flake outputs) as inputs.
{ }:
{ config, lib, pkgs, self, ... }:

with lib;
let
  # Module configuration options defined by the user
  cfg = config.services.nix-orbstack;
in {
  # --- Module Options Definition ---
  options.services.nix-orbstack = {
    enable = mkEnableOption "NixOS VM named '${name}' managed by OrbStack";

    configuration = mkOption {
      type = types.deferredModule;
      example = literalExpression ''
        ({ pkgs, ... }:

        {
          environment.systemPackages = [ pkgs.neovim ];
        })
      '';
    };
    # Note: Disk size is primarily controlled by virtualisation.diskSize in the NixOS config.
    # OrbStack's import command uses the size defined within the QCOW2 image.
  };

  # --- Module Configuration Implementation ---
  config = mkIf cfg.enable {
    # Ensure the orb CLI is available in the PATH for the activation script.
    # It's added only if there are VMs configured to avoid unnecessary dependencies.
    # environment.systemPackages =
    #   mkIf (config.services.nix-orbstack != { }) [ pkgs.orbstack ];

    homebrew.casks = homebrew.casks ++ [ orbstack ];

    # Use a nix-darwin activation script to perform the imperative steps of
    # checking and importing the VM into OrbStack after the Nix build is complete.
    # system.activationScripts.orbstackNixosVms = let
    #   # Generate a list of enabled VM configurations
    #   vmEntries = mapAttrsToList (vmName: vmConfig:
    #     # Only include VMs where enable = true;
    #     mkIf vmConfig.enable {
    #       name = vmName; # The key used in services.orbstack-nixos-vms.<name>
    #       config =
    #         vmConfig; # The full configuration for this VM { enable, nixosConfigurationFlakeRef, ... }
    #       # Build the image derivation *during Nix evaluation* and store its store path
    #       imageDrv = buildVmImage vmConfig.nixosConfigurationFlakeRef;
    #     }) cfg; # cfg is config.services.orbstack-nixos-vms
    #
    #   # Construct the shell script text
    #   script = concatStringsSep "\n" (map
    #     (vm: # vm is an entry from vmEntries list
    #       let
    #         # Safely escape arguments for shell command usage
    #         vmNameArg = escapeShellArg vm.name;
    #         # Nix will substitute the actual /nix/store path here
    #         imagePathArg = escapeShellArg vm.imageDrv;
    #         # Construct optional arguments for orb import
    #         cpuArg = optionalString (vm.config.cpu != null)
    #           "--cpu ${toString vm.config.cpu}";
    #         memArg = optionalString (vm.config.memory != null)
    #           "--memory ${escapeShellArg vm.config.memory}";
    #       in ''
    #         # Activation script snippet for VM: ${vm.name}
    #         echo "--> Checking OrbStack NixOS VM: ${vm.name}"
    #
    #         # Use 'orb status' to check if VM exists (more reliable than parsing 'orb list')
    #         # Redirect stdout and stderr to /dev/null, check exit code
    #         if ${pkgs.orbstack}/bin/orb status ${vmNameArg} >/dev/null 2>&1; then
    #           # VM Exists: Print message and do nothing (manual update required)
    #           echo "VM '${vm.name}' already exists in OrbStack. Skipping import."
    #           echo "    (To update: 'orb destroy -f ${vm.name}' then re-run darwin-rebuild switch)"
    #         else
    #           # VM Does Not Exist: Attempt to import the built image
    #           echo "VM '${vm.name}' not found. Importing image from: ${vm.imageDrv}"
    #           # Execute the orb import command with options
    #           if ${pkgs.orbstack}/bin/orb import ${imagePathArg} --name ${vmNameArg} ${cpuArg} ${memArg}; then
    #              # Success message
    #              echo "Successfully imported VM '${vm.name}' into OrbStack."
    #           else
    #              # Error message
    #              echo "ERROR: Failed to import VM '${vm.name}' into OrbStack." >&2
    #              # Fail the activation script if import fails to prevent partial activation
    #              exit 1
    #           fi
    #         fi
    #       '') vmEntries); # End map over vmEntries
    #
    # in { # Attributes for the activation script entry
    #   supportsDryActivation =
    #     true; # Script mainly checks status and calls import, should be safe for dry runs
    #   text = ''
    #     # Wrapper script executed during darwin activation
    #     echo "[INFO] Managing OrbStack NixOS VMs..."
    #     # Exit immediately if any command fails within this script block
    #     set -e
    #     # Execute the generated script snippets for each VM
    #     ${script}
    #     # Disable exit on error after the main logic
    #     set +e
    #     echo "[INFO] OrbStack NixOS VM management complete."
    #   '';
    # }; # End system.activationScripts.orbstackNixosVms
  }; # End config block
}
