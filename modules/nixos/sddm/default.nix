{
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    settings.General.GreeterEnvironment = "QT_SCREEN_SCALE_FACTORS=2";
  };

  nixpkgs.overlays = [
    (_: prev: {
      weston = prev.weston.override { vncSupport = false; };
    })
  ];
}
