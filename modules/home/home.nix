{ lib, ... }:
{
  home = {
    username = "mattr-";
    homeDirectory = lib.mkDefault "/home/mattr-";
    stateVersion = "24.05";
  };

}
