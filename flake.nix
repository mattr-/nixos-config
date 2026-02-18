{
  description = "NixOS and nix-darwin configs for mattr-";

  inputs = {
    nixpkgs.url = "git+https://github.com/NixOS/nixpkgs?shallow=1&ref=nixos-unstable";

    # Disko for declarative disk partitioning
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    # Declarative Flatpak management
    flatpaks.url = "github:gmodena/nix-flatpak?ref=latest";

    # Hardware support
    hardware.url = "github:NixOS/nixos-hardware";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # LLM Agents
    llm-agents.url = "github:numtide/llm-agents.nix";

    # Modded minecraft server management
    minecraft-servers.url = "github:mkaito/nixos-modded-minecraft-servers";

    # Noctalia
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Quickshell from git
    quickshell = {
      url = "github:quickshell-mirror/quickshell";
    };

    # Vicinae - Raycast clone for Linux
    vicinae.url = "github:vicinaehq/vicinae?ref=v0.16.14";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      home-manager,
      flake-parts,
      flatpaks,
      vicinae,
      ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        ./modules
        ./hosts
      ];
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];
      perSystem =
        {
          config,
          self',
          inputs',
          pkgs,
          system,
          ...
        }:
        {
          _module.args.pkgs = import nixpkgs {
            inherit system;
            overlays = [ self.overlays.default ];
            config.allowUnfree = true;
          };

          packages.plannotator = pkgs.plannotator;

          formatter = pkgs.nixfmt-tree;
        };
      flake = {
        # The usual flake attributes can be defined here, including system-
        # agnostic ones like nixosModule and system-enumerating ones, although
        # those are more easily expressed in perSystem.
        lib = import ./lib { inherit (nixpkgs) lib; };

        overlays.default = final: prev: {
          plannotator = final.callPackage ./pkgs/plannotator { };
        };
      };
    };
}
