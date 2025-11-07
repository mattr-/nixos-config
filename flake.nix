{
  description = "NixOS and nix-darwin configs for mattr-";

  inputs = {
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    nixpkgs.url = "git+https://github.com/NixOS/nixpkgs?shallow=1&ref=nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Disko for declarative disk partitioning
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    # Hardware support
    hardware.url = "github:NixOS/nixos-hardware";

    # Declarative Flatpak management
    flatpaks.url = "github:gmodena/nix-flatpak?ref=latest";

    # Vicinae - Raycast clone for Linux
    vicinae.url = "github:vicinaehq/vicinae?ref=v0.15.7";
  };

  outputs = inputs@{ self, nixpkgs, home-manager, flake-parts, flatpaks, vicinae, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        ./modules
        ./hosts
      ];
      systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin" ];
      perSystem = { config, self', inputs', pkgs, system, ... }: {
        # Per-system attributes can be defined here. The self' and inputs'
        # module parameters provide easy access to attributes of the same
        # system.

        # Equivalent to  inputs'.nixpkgs.legacyPackages.hello;
        # packages.default = pkgs.hello;
        formatter = pkgs.nixfmt-tree;
      };
      flake = {
        # The usual flake attributes can be defined here, including system-
        # agnostic ones like nixosModule and system-enumerating ones, although
        # those are more easily expressed in perSystem.

      };
    };
}
