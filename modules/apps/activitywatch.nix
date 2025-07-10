{pkgs, ...}: {
  my._packages = with pkgs; [activitywatch];

  environment.etc."xdg/autostart/aw-qt.desktop".source = "${pkgs.activitywatch}/share/applications/aw-qt.desktop";
}
