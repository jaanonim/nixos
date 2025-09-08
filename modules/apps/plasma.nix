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
        kdePackages.korganizer
        kdePackages.akonadi
        kdePackages.kdepim-addons
        kdePackages.kdepim-runtime
        kdePackages.kwallet
      ]
      ++ (with jaanonim-pkgs; [bible-runner]);
  };
}
