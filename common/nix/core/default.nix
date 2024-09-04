{...}: {
  imports = [
    ./localization.nix
    ./nixos.nix
    ./zsh.nix
    ./boot.nix
    ./networking.nix
  ];

  hardware.enableRedistributableFirmware = true;
}
