{
  networking.hostName = "slugworth";

  programs.sway.enable = true;
  programs.niri.enable = true;

  security = {
    # allow wayland lockers to unlock the screen
    pam.services.hyprlock.text = "auth include login";
  };
}
