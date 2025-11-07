{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.dots.hardware;
in
{
  options.dots.hardware = {
    gpu = lib.mkOption {
      type = lib.types.enum [
        "intel"
        "nvidia"
        "amd"
      ];
      default = "intel";
      description = "The type of GPU installed in the system";
    };
  };

  config = {
    # Base graphics configuration for all GPU types
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        libva
        libva-vdpau-driver
        libvdpau-va-gl
        mesa
      ] ++ (
        # GPU-specific packages
        lib.optionals (cfg.gpu == "intel") [
          intel-media-driver
          intel-compute-runtime
        ] ++ lib.optionals (cfg.gpu == "amd") [
          rocmPackages.clr.icd
        ]
      );
      extraPackages32 = with pkgs.pkgsi686Linux; [
        libva-vdpau-driver
        libvdpau-va-gl
      ];
    };

    # GPU-specific video drivers
    services.xserver.videoDrivers = lib.mkDefault (
      if cfg.gpu == "intel" then
        [ "intel" ]
      else if cfg.gpu == "nvidia" then
        [ "nvidia" ]
      else if cfg.gpu == "amd" then
        [ "amdgpu" ]
      else
        [ ]
    );

    # AMD-specific kernel parameters
    boot.kernelParams = lib.mkIf (cfg.gpu == "amd") [
      # Valve says:
      #
      # We set amdgpu.lockup_timeout in order to control the TDR for each ring
      # 0 (GFX): 5s (was 10s)
      # 1 (Compute): 10s (was 60s wtf)
      # 2 (SDMA): 10s (was 10s)
      # 3 (Video): 5s (was 10s)

      # ttm.pages_min is set to 8GB in units of page size (4096), which is min
      # required for decent gaming performance.
      # amdgpu.sched_hw_submission is set to 4 to avoid bubbles of lack-of work
      # with the default (2).
      # 4 is the maximum that is supported across RDNA2 + RDNA3.
      # Any more results in a hang at startup on RDNA3.
      "amd_iommu=off"
      "amdgpu.lockup_timeout=5000,10000,10000,5000"
      "ttm.pages_min=2097152"
      "amdgpu.sched_hw_submission=4"
    ];

    # NVIDIA-specific configuration
    hardware.nvidia = lib.mkIf (cfg.gpu == "nvidia") {
      modesetting.enable = lib.mkDefault true;
      powerManagement.enable = lib.mkDefault true;
      open = lib.mkDefault false;
      nvidiaSettings = lib.mkDefault true;
    };
  };
}
