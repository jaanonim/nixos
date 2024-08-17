{
  pkgs,
  configLib,
  ...
}: {
  packages = with pkgs; [
    discord
  ];

  environment.etc."xdg/autostart/discord.desktop".source = "${configLib.get_util "discord-autostart" {inherit pkgs;}}/discord.desktop";
}
