{ pkgs, ... }:
{
  home.packages = with pkgs; [
    cliphist
    dunst
    swayosd
    swww
    waybar
    wev
    wl-clipboard
    wlsunset
  ];
}
