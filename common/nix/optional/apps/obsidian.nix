{pkgs, ...}: {
  packages = with pkgs; [
    obsidian
    git
  ];

  environment.etc."xdg/autostart/obsidian.desktop".source = "${pkgs.obsidian}/share/applications/obsidian.desktop";
}
