{ pkgs, ... }:
{
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
    hyprland
    hypridle
    hyprlock
  ];
}
