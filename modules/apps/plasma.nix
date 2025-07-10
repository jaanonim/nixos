{
  pkgs,
  config,
  lib,
  jaanonim-pkgs,
  ...
}:
with lib; let
  my = config.my;
in {
  config = mkIf (builtins.any (ele: (ele == (lib.removeSuffix ".nix" (baseNameOf __curPos.file)))) my.apps) {
    my._packages = with pkgs;
      [
        kdePackages.korganizer
        kdePackages.akonadi
        kdePackages.kdepim-addons
        kdePackages.kdepim-runtime
        libsForQt5.korganizer
        libsForQt5.akonadi
        libsForQt5.kdepim-runtime
      ]
      ++ (with jaanonim-pkgs; [bible-runner]);
  };
}
