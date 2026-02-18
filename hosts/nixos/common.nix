{ self, ... }:
let
  vmMachineConfig = {
    memorySize = 8192; # 8GB of RAM
    cores = 4; # 4 cores
  };
in
{
  nixpkgs.overlays = [ self.overlays.default ];

  # better settings for nixos-rebuild build-vm
  #
  # the defaults are very low and very minimal and that won't support the
  # testing i want to do with build-vm.
  virtualisation.vmVariant.virtualisation = vmMachineConfig;
  virtualisation.vmVariantWithBootLoader.virtualisation = vmMachineConfig;

  # NixOS 24.05 is the first version of NixOS ran with this config.
  # Do not change this value.
  system.stateVersion = "24.05";
}
