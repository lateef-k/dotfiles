#!/usr/bin/env sh

trap 'echo "Error occurred at line $LINENO"; exit 1' ERR # execute this command if any command returns non-zero
set -e # exit immediately for non-zero
set -u # exit if undefined variables
set -o pipefail # pipe will return non-zero if any command fails

# Function to bootstrap system
bootstrap_system() {
    local hostname="$1"
    # Check the operating system
    if [ "$(uname)" = "Linux" ]; then
        # Command to run on Linux
        echo "OS: Linux"
        echo "Running nixos-rebuild for the first time..."
        # Replace the echo below with your actual Linux command
        sudo nixos-rebuild switch --extra-experimental-features flakes --flake .#"$hostname" --impure
    elif [ "$(uname)" = "Darwin" ]; then
        echo "OS: Darwin"
        echo "Running nix-darwin for the first time..."
        nix run --extra-experimental-features nix-command --extra-experimental-features flakes nix-darwin -- switch --flake .#"$hostname" --impure
    else
        # Unknown operating system
        echo "Unknown OS: $(uname)"
        exit 1
    fi
}

# Function to bootstrap home
bootstrap_home() {
    local home_manager_release="$1"

    echo "Running home-manager init..."
    nix run github:nix-community/home-manager/"$home_manager_release" -- init --switch
}

# Function to initialize disk using disko
init_disk() {
    local nixos_output="$1"
    local disk="$2"

    echo "Initializing disk $disk with configuration $nixos_output..."
    sudo nix --experimental-features "nix-command flakes" run 'github:nix-community/disko#disko-install' -- \
        --show-trace --write-efi-boot-entries --flake ".#$nixos_output" --disk main "$disk"
}

# Check if argument is provided
if [ $# -lt 1 ]; then
    echo "Error: At least one argument is required"
    echo "Usage: $0 <system|home|init-disk> [arguments]"
    exit 1
fi

case "$1" in
    "system")
        # Check if hostname is provided
        if [ $# -lt 2 ]; then
            echo "Error: Hostname is required for system bootstrap"
            echo "Usage: $0 system <hostname>"
            exit 1
        fi

        bootstrap_system "$2"
        ;;

    "home")
        # Check if home-manager release is provided
        if [ $# -lt 2 ]; then
            echo "Error: Home-manager release is required for home bootstrap"
            echo "Usage: $0 home <home-manager-release>"
            exit 1
        fi

        bootstrap_home "$2"
        ;;

    "init-disk")
        # Check if required parameters are provided
        if [ $# -lt 3 ]; then
            echo "Error: NixOS output and disk are required for disk initialization"
            echo "Usage: $0 init-disk <nixos-output> <disk>"
            exit 1
        fi

        init_disk "$2" "$3"
        ;;

    *)
        echo "Error: Invalid argument"
        echo "Usage: $0 <system|home|init-disk> [arguments]"
        exit 1
        ;;
esac

exit 0
