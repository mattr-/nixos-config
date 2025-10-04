{ inputs, pkgs, ...}:
{
  imports = [
    inputs.niri.homeModules.niri
    inputs.dankMaterialShell.homeModules.dankMaterialShell.default
    inputs.dankMaterialShell.homeModules.dankMaterialShell.niri
  ];

  programs.niri.enable = true;
  programs.dankMaterialShell = {
    enable = true;
    enableVPN = false;
  };
}
