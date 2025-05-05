{ inputs, self, lib, ... }:
let
  # Get all subdirectories in the hosts directory
  hostAttrs = builtins.attrNames (builtins.readDir ./.);

  # Filter out non-directories and any special files/folders (like default.nix itself)
  hostNames = builtins.filter (name:
    builtins.pathExists (./. + "/${name}/default.nix") &&
    builtins.isAttrs (builtins.readDir (./. + "/${name}"))
  ) hostAttrs;

  nixosGenerator =
    machine:
    let
      path = # This will resolve to machine.nix if file is there else machine
        # Will help to include a dir with multiple files
        if builtins.pathExists ./${machine + ".nix"} then ./${machine + ".nix"} else ./${machine};
    in
    inputs.nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit inputs self;
      };
      modules = [
        ./common.nix # nixos Common settings
        # machine specific settings tweaks
        path
      ];
    };
in
{
  flake.nixosConfigurations = (lib.genAttrs hostNames nixosGenerator);
}
