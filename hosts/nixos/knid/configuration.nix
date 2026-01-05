{inputs, outputs, pkgs, ...}: {

  networking.hostName = "knid";

  dots.hardware.gpu = "amd";

  hardware.brillo.enable = true;

  virtualisation.waydroid.enable = true;

  programs.niri.enable = true;

  environment.systemPackages = with pkgs; [
    quickshell
    matugen
    ddcutil
    khal
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  security = {
    # allow wayland lockers to unlock the screen
    pam.services.hyprlock.text = "auth include login";
  };
}
