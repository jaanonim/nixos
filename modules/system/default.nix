_: {
  # imports = builtins.map (path: ./. + /${path}) (builtins.attrNames (builtins.removeAttrs (builtins.readDir ./.) [default.nix]));
  imports = [
    ./apps.nix
    ./audio.nix
    ./bluetooth.nix
    ./boot.nix
    ./certificates.nix
    ./core.nix
    # ./devices.nix
    ./disks.nix
    ./docker.nix
    ./flatpack.nix
    ./localization.nix
    ./networking.nix
    # ./nixos.nix
    # ./plasma
    ./sddm.nix
    # ./shell.nix
    # ./sops.nix
    ./timers.nix
    # ./udev.nix
    ./user.nix
    ./vfio.nix
    ./virtualisation.nix
    ./vpn.nix
  ];
}
