{pkgs, ...}:
pkgs.runCommand "discord-autostart" {} ''
  mkdir -p $out/share/applications
  substitute ${pkgs.discord-canary}/share/applications/discord-canary.desktop $out/share/applications/discord.desktop \
    --replace "Exec=DiscordCanary" "Exec=DiscordCanary --start-minimized"
''
