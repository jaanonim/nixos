{
  configLib,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    configLib.core
    (configLib.optional /teminal.nix)
    (configLib.optional /plasma.nix)
    #    (configLib.optional /devices.nix)
    (configLib.optional /flatpack.nix)
    (configLib.optional /virtualbox.nix)

    (configLib.users /jaanonim)
    ./colors.nix
  ];

  networking.hostName = "laptop";

  virtualisation.docker.enable = true;

  system.stateVersion = "23.11"; # Don't touch

  environment.etc."xdg/autostart/discord.desktop".source = pkgs.runCommand "discord-desktop-minimized" {} ''
    mkdir -p $out/share/applications
    substitute ${pkgs.discord}/share/applications/discord.desktop $out/share/applications/discord.desktop \
      --replace "Exec=Discord" "Exec=Discord --start-minimized"
  '';
}
