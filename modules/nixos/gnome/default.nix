{ pkgs, ... }:
{
  services.desktopManager.gnome.enable = true;
  services.displayManager.gdm.enable = true;

  environment.systemPackages = with pkgs; [
    gnomeExtensions.appindicator
    gnomeExtensions.paperwm
  ];
  services.udev.packages = [ pkgs.gnome-settings-daemon ];
  services.gnome.gcr-ssh-agent.enable = false;
  # services.gnome.core-apps.enable = false;
  services.orca.enable = false;
}
