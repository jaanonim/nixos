{outputs, ...}: {
  imports = [
    ./localization.nix
    ./nixos.nix
    ./zsh.nix
    ./boot.nix
    ./networking.nix
  ];

  nixpkgs = {
    overlays = builtins.attrValues outputs.overlays;
    config = {
      allowUnfree = true;
    };
  };
  hardware.enableRedistributableFirmware = true;
}
