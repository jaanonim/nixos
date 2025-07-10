{configLib, ...}: {
  imports = [
    ./hardware-configuration.nix
    ./colors.nix

    configLib.core
    (configLib.optional /teminal.nix)
    (configLib.optional /plasma.nix)
    (configLib.optional /devices.nix)
    (configLib.optional /flatpack.nix)
    (configLib.optional /virtualisation.nix)
    (configLib.optional /cursor-fix.nix)
    (configLib.optional /vpn.nix)
    (configLib.optional /disks.nix)
    (configLib.optional /security.nix)
    (configLib.optional /bluetooth.nix)
    (configLib.optional /timers.nix)
    (configLib.optional /sddm.nix)
    (configLib.optional /udev.nix)
    (configLib.optional /audio.nix)
    (configLib.optional /docker.nix)
    (configLib.optional /vfio.nix)

    (configLib.users /jaanonim)
  ];

  system.stateVersion = "24.05"; # Don't touch
}
