{ inputs, pkgs, lib, self, config, ... }:
{
  imports =
    self.lib.directoryImport ./.
    ++ [
      self.nixosModules.boot
      self.nixosModules.nix
      self.nixosModules.users
      self.nixosModules.network
    ];
}
