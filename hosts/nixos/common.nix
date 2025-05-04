{
  # better settings for nixos-rebuild build-vm
  virtualisation.vmVariant = {
    virtualisation = {
      memorySize = 8192; # 8GB of RAM
        cores = 4; # 4 cores
    };
  };

  virtualisation.vmVariantWithBootLoader = {
    virtualisation = {
      memorySize = 8192; # 8GB of RAM
        cores = 4; # 4 cores
    };
  };


  system.stateVersion = "24.05";
}
