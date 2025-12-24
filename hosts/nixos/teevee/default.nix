{ inputs, pkgs, lib, self, config, ... }:
{
  imports =
    with builtins;
    map (fn: ./${fn}) (
      filter (fn: (fn != "default.nix" && !lib.hasSuffix ".md" "${fn}")) (attrNames (readDir ./.))
    )
    ++ [
      self.nixosModules.boot
      self.nixosModules.nix
      self.nixosModules.users
      self.nixosModules.network
    ];
}
