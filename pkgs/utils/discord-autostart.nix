{pkgs, ...}:
pkgs.runCommand "discord-autostart" {} ''
  mkdir -p $out/share/applications
  substitute ${pkgs.discord}/share/applications/discord.desktop $out/discord.desktop \
    --replace "Exec=Discord" "Exec=Discord --start-minimized"
''
