{ inputs, pkgs, ... }:
{
  imports = [
    inputs.vicinae.homeManagerModules.default
  ];

  home.packages = with pkgs; [
    cliphist
    dunst
    swayosd
    swww
    waybar
    wev
    wofi
    wl-clipboard
    wlsunset
  ];

  services.vicinae = {
    enable = true;
    autoStart = true;
  };
}
