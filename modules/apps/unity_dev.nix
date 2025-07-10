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
    my._packages = with pkgs; [
      jaanonim-pkgs.rider
      unityhub
    ];

    home-manager.users.${my.mainUser}.home.file = mkIf my.homeManager {
      ".local/share/applications/jetbrains-rider.desktop".source = "${jaanonim-pkgs.riderDesktop}/share/applications/jetbrains-rider.desktop";
    };
  };
}
