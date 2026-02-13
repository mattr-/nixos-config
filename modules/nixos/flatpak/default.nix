{
  self,
  inputs,
  lib,
  ...
}:
{
  imports = [
    inputs.flatpaks.nixosModules.nix-flatpak
  ];

  services.flatpak = {
    enable = true;
    packages = [
      "org.signal.Signal"
    ];
  };
}
