{ inputs, pkgs, lib, self, config, ... }:
{
  imports =
    with builtins;
    map (fn: ./${fn}) (
      filter (fn: (fn != "default.nix" && !lib.hasSuffix ".md" "${fn}")) (attrNames (readDir ./.))
    )
    ++ (builtins.attrValues self.nixosModules);

  hm.imports = builtins.attrValues self.homeModules;
}
