{pkgs, ...}: {
  packages = with pkgs; [
    discord
  ];
  autostart = {
    "xdg/autostart/obsidian.desktop".source = "${pkgs.obsidian}/share/applications/obsidian.desktop";
  };
}
