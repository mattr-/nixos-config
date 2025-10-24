{ config, pkgs, lib, ... }:
{
  # GNOME-specific settings via dconf
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      # Prefer dark color scheme for GNOME applications
      color-scheme = "prefer-dark";
    };
  };
}
