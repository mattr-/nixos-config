{ inputs, ... }:
{
  imports = [inputs.niri.homeModules.niri ./settings.nix ./binds.nix ./rules.nix];
}
