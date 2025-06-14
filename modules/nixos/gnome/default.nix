{ pkgs, ... }:
{
  services.desktopManager.gnome.enable = true;
  services.displayManager.gdm.enable = true;

  environment.systemPackages = [ pkgs.gnomeExtensions.appindicator ];
  services.udev.packages = [ pkgs.gnome-settings-daemon ];
}
