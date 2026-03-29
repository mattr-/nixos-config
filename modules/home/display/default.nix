{ lib, ... }:
{
  options.dots.display = {
    scale = lib.mkOption {
      type = lib.types.number;
      default = 1;
      description = "Scaling factor for graphical Wayland displays";
    };
  };
}
