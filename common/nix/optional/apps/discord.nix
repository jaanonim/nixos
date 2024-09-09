{
  pkgs,
  configLib,
  ...
}: {
  packages = [
    # TODO: This override is not working
    (pkgs.discord.overrideAttrs (oldAttrs: {
      desktopItem = oldAttrs.desktopItem.override {
        exec = "env XDG_SESSION_TYPE=x11 Discord";
      };
    }))
  ];

  environment.etc."xdg/autostart/discord.desktop".source = "${configLib.get_util "discord-autostart" {inherit pkgs;}}/share/applications/discord.desktop";
}
