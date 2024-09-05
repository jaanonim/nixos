{...}: {
  imports = [
    ./localization.nix
    ./nixos.nix
    ./zsh.nix
    ./boot.nix
    ./networking.nix
    ./sops.nix
  ];

  hardware.enableRedistributableFirmware = true;
}
