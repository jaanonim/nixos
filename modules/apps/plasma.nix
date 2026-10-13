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
    my._packages =
      (with pkgs.kdePackages; [
        korganizer
        akonadi
        akonadi-contacts
        akonadi-calendar
        akonadi-calendar-tools
        kdepim-addons
        kdepim-runtime
        kwallet
      ])
      ++ (with jaanonim-pkgs; [bible-runner]);

    programs.kde-pim.enable = false; # merkuro is a combined package with mail and contacts, so use older korganizer for now
  };
}
