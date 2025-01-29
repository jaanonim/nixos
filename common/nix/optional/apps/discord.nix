{
  pkgs,
  configLib,
  ...
}: {
  packages = [
    pkgs.discord-canary
  ];

  environment.etc."xdg/autostart/discord.desktop".source = "${configLib.get_util "discord-autostart" {inherit pkgs;}}/share/applications/discord.desktop";
}
