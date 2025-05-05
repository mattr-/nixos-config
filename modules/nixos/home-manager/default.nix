{
  self,
  inputs,
  lib,
  ...
}:
{
  imports = [
    inputs.home-manager.nixosModules.home-manager

    # Make sure to use hm = { imports = [ ./<homemanagerFiles> ];}; in nixosconfig
    {
      home-manager = {
        backupFileExtension = "bak";
        extraSpecialArgs = { inherit inputs self; };
        useGlobalPkgs = true;
        useUserPackages = true;
      };
    }

    # config.home-manager.users.${user} -> config.hm
    (lib.mkAliasOptionModule [ "hm" ] [ "home-manager" "users" "mattr-" ])

  ];

  hm.imports = [
    self.homeModules.home
  ];
}
