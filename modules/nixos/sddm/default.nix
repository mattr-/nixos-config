{
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  nixpkgs.overlays = [
    (_: prev: {
      weston = prev.weston.override { vncSupport = false; };
    })
  ];
}
