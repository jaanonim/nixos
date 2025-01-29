{pkgs, ...}:
pkgs.runCommand "discord-autostart" {} ''
  mkdir -p $out/share/applications
  substitute ${pkgs.discord-canary}/share/applications/discord-canary.desktop $out/share/applications/discord.desktop \
    --replace "Exec=Discord" "Exec=env XDG_SESSION_TYPE=x11 Discord --start-minimized"
''
