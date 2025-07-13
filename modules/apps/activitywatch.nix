{
  pkgs,
  config,
  lib,
  ...
}:
with lib; {
  config = mkIf (builtins.any (ele: (ele == (lib.removeSuffix ".nix" (baseNameOf __curPos.file)))) config.my.apps) {
    my._packages = with pkgs; [activitywatch];

    environment.etc."xdg/autostart/aw-qt.desktop".source = "${pkgs.activitywatch}/share/applications/aw-qt.desktop";
  };
}
