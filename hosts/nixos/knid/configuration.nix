{inputs, outputs, pkgs, ...}: {

  networking.hostName = "knid";

  hardware.brillo.enable = true;

  programs.niri.enable = true;

  environment.systemPackages = with pkgs; [
    quickshell
  ];

  security = {
    # allow wayland lockers to unlock the screen
    pam.services.hyprlock.text = "auth include login";
  };
}
