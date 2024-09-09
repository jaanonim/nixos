{configLib, ...}: {
  imports = [
    ./hardware-configuration.nix
    configLib.core
    (configLib.optional /teminal.nix)
    (configLib.optional /plasma.nix)
    (configLib.optional /devices.nix)
    (configLib.optional /flatpack.nix)
    (configLib.optional /virtualisation.nix)
    (configLib.optional /cursor-fix.nix)
    (configLib.optional /vpn.nix)
    (configLib.optional /disks.nix)
    (configLib.optional /bluetooth.nix)

    (configLib.users /jaanonim)
    ./colors.nix
  ];

  networking.hostName = "laptop";
  services.openssh.enable = true;

  system.stateVersion = "24.05"; # Don't touch
}
