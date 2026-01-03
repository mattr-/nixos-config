{
  networking.hostName = "slugworth";

  dots.hardware.gpu = "amd";

  programs.sway.enable = true;
  programs.niri.enable = true;
  programs.dms-shell.enable = true;

  security = {
    # allow wayland lockers to unlock the screen
    pam.services.hyprlock.text = "auth include login";
  };
}
