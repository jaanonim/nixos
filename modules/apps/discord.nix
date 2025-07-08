{pkgs, ...}: let
  discord-autostart = pkgs.runCommand "discord-autostart" {} ''
    mkdir -p $out/share/applications
    substitute ${pkgs.discord}/share/applications/discord.desktop $out/share/applications/discord.desktop \
      --replace "Exec=Discord" "Exec=Discord --start-minimized"
  '';
in {
  packages = [
    pkgs.discord
  ];

  environment.etc."xdg/autostart/discord.desktop".source = "${discord-autostart}/share/applications/discord.desktop";
}
