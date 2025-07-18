{
  pkgs,
  config,
  lib,
  jaanonim-pkgs,
  ...
}:
with lib; let
  inherit (config) my;
in {
  config = mkIf (builtins.any (ele: (ele == (lib.removeSuffix ".nix" (baseNameOf __curPos.file)))) my.apps) {
    my._packages = with pkgs;
      [
        nix
        git
        nixpkgs-fmt
        alejandra
        nixd
        nil
        direnv
      ]
      ++ (with jaanonim-pkgs; [
        nsearch
      ]);
  };
}
