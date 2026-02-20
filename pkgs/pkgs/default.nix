{
  pkgs,
  lib,
  ...
}: (
  lib.foldl (a: b: a // b) {}
  (
    map (path: (
      let
        pkg = pkgs.callPackage "${./.}/${path}" {};
      in {"${pkg.name}" = pkg;}
    )) (builtins.attrNames (removeAttrs (builtins.readDir ./.) ["default.nix"]))
  )
)
