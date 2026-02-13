{ lib, ... }:
{
  directoryImport =
    dir:
    with builtins;
    map (filename: dir + "/${filename}") (
      filter (filename: (filename != "default.nix" && !lib.hasSuffix ".md" "${filename}")) (
        attrNames (readDir dir)
      )
    );
}
