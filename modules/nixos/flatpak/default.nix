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
      "com.microsoft.Edge" # xbox cloud gaming
    ];
    overrides = {
      "com.microsoft.Edge".Context = {
        filesystems = [
          "/run/udev:ro"
        ];
      };
    };
  };
}
