{...}: {
  imports = [
    ./localization.nix
    ./nixos.nix
    ./zsh.nix
    ./boot.nix
    ./networking.nix
  ];

  nixpkgs.config.allowUnfree = true;
  hardware.enableRedistributableFirmware = true;
}
