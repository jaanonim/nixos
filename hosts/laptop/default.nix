{configLib, ...}: {
  imports = [
    ./hardware-configuration.nix
    configLib.core
    (configLib.optional /teminal.nix)
    (configLib.optional /plasma.nix)
    #    (configLib.optional /devices.nix)
    (configLib.optional /flatpack.nix)
    (configLib.optional /virtualisation.nix)
    (configLib.optional /cursor_fix.nix)

    (configLib.users /jaanonim)
    ./colors.nix
  ];

  networking.hostName = "laptop";

  system.stateVersion = "23.11"; # Don't touch
}
