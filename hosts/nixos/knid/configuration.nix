{inputs, outputs, pkgs, ...}: {

  networking.hostName = "knid";

  hardware.brillo.enable = true;

  programs.niri.enable = true;

  security = {
    # allow wayland lockers to unlock the screen
    pam.services.hyprlock.text = "auth include login";
  };
}
