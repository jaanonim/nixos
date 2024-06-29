{pkgs, ...}: {
  packages = with pkgs; [
    discord
  ];

  environment.etc."xdg/autostart/discord.desktop".source = "${pkgs.discord-autostart}/discord.desktop";
}
