{ inputs, pkgs, ... }:
{
  networking.hostName = "slugworth";

  dots.hardware.gpu = "amd";

  programs.sway.enable = true;
  programs.niri.enable = true;

  virtualisation.waydroid.enable = true;

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
