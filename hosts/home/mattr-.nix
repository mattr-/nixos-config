{
  self,
  inputs,
  pkgs,
  opts,
  ...
}:
{
  imports = [
    self.homeModules.cli
    self.homeModules.gtk
    self.homeModules.home
    self.homeModules.ported
    self.homeModules.wayland
  ];
}
