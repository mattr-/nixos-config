# taken from niksingh710/ndots/hosts/home/default.nix
# and modified by mattr-
{ self, inputs, pkgs, ... }:
let
  hmGenerator =
    machine: system:
    let
      path = # This will resolve to machine.nix if file is there else machine
        # Will help to include a dir with multiple files
        if builtins.pathExists ./${machine + ".nix"} then ./${machine + ".nix"} else ./${machine};
    in
    inputs.home-manager.lib.homeManagerConfiguration rec {
      # pkgs is from the flake's inputs.nixpkgs
      pkgs = import inputs.nixpkgs {
        config.allowUnfree = true;
        inherit system;
      };
      # extraSpecialArgs is alter to `_module.args` for homeManagerConfiguration
      # Check the home-manager module github for more args accepted by homeManagerConfiguration
      extraSpecialArgs = {
        # self is the flake-parts way to refer this flake
        inherit
          self
          inputs
          pkgs
          ;
      };
      modules = [
        # machine specific settings tweaks
        # If the machine specific settings are grwoing much then create a dir
        # default.nix inside the dir will be imported here
        ./mattr-.nix
      ];
    };

in
{
  flake.homeConfigurations = {
    # General standalone config for both NixOS and non-NixOS systems
    "mattr-" = hmGenerator "mattr-" "x86_64-linux";
  };
}
