{pkgs, ...}: {
  packages = with pkgs; [activitywatch];
  autostart = {
    "xdg/autostart/aw-qt.desktop".source = "${pkgs.activitywatch}/share/applications/aw-qt.desktop";
  };
}
