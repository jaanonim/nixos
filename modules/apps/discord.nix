{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  inherit (config) my;
in {
  config = mkIf (builtins.any (ele: (ele == (lib.removeSuffix ".nix" (baseNameOf __curPos.file)))) my.apps) {
    my._packages = [
      pkgs.discord
    ];

    environment.etc."xdg/autostart/discord.desktop".source = let
      discord-autostart = pkgs.runCommand "discord-autostart" {} ''
        mkdir -p $out/share/applications
        substitute ${pkgs.discord}/share/applications/discord.desktop $out/share/applications/discord.desktop \
          --replace "Exec=Discord" "Exec=Discord --start-minimized"
      '';
    in "${discord-autostart}/share/applications/discord.desktop";
  };
}
