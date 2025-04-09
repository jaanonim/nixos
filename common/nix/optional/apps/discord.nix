{
  pkgs,
  configLib,
  ...
}: {
  packages = [
    pkgs.discord
  ];

  environment.etc."xdg/autostart/discord.desktop".source = "${configLib.get_util "discord-autostart" {inherit pkgs;}}/share/applications/discord.desktop";
}
