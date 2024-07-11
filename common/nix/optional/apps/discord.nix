{pkgs, ...}: {
  packages = with pkgs; [
    discord
  ];

  environment.etc."xdg/autostart/obsidian.desktop".source = "${pkgs.obsidian}/share/applications/obsidian.desktop";
}
