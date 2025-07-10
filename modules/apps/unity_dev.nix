{
  pkgs,
  jaanonim-pkgs,
  config,
  lib,
  ...
}:
with lib; let
  my = config.my;
in {
  my._packages = with pkgs; [
    jaanonim-pkgs.rider
    unityhub
  ];

  home-manager.users.${my.mainUser}.home.file = mkIf my.homeManager {
    ".local/share/applications/jetbrains-rider.desktop".source = "${jaanonim-pkgs.riderDesktop}/share/applications/jetbrains-rider.desktop";
  };
}
