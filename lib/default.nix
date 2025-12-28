{ lib }:
let
  directoryImport = import ./directory_import.nix { inherit lib; };
in
  directoryImport
