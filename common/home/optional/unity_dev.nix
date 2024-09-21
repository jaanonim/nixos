{jaanonim-pkgs, ...}: {
  home.file = {
    ".local/share/applications/jetbrains-rider.desktop".source = "${jaanonim-pkgs.riderDesktop}/share/applications/jetbrains-rider.desktop";
  };
}
