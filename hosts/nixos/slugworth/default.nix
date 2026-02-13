{
  inputs,
  pkgs,
  lib,
  self,
  config,
  ...
}:
{
  imports = self.lib.directoryImport ./. ++ [
    self.nixosModules.boot
    self.nixosModules.nix
    self.nixosModules.users
    self.nixosModules.network
    self.nixosModules.home-manager
    self.nixosModules.bluetooth
    self.nixosModules.flatpak
    self.nixosModules.gnome
    self.nixosModules.wayland
    self.nixosModules.graphics
    self.nixosModules.games
    self.nixosModules.utils
    self.nixosModules.ported
  ];

  hm.imports = with self.homeModules; [
    cli
    home
    go
    gnome
    gtk
    wayland
    ported
  ];
}
