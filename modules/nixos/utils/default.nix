{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    file
    unzip
    zip
  ];
}
