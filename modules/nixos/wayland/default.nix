{
  programs.hyprland = {
    enable = true;
    withUWSM = true; # recommended for most users
    xwayland.enable = true;
  };

  programs.hyprlock.enable = true;
  services.hypridle.enable = true;

  # Electron apps should use Wayland
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}
