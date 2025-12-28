{ inputs, pkgs, lib, self, config, ... }:
{
  imports =
    self.lib.directoryImport ./.
    ++ (builtins.attrValues self.nixosModules);

  hm.imports = builtins.attrValues self.homeModules;
}
