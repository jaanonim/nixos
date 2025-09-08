{
  lib,
  self,
  inputs,
  ...
}: {
  flakePart = lib.makeHost {
    inherit self;
    deploy = false;
    system = "aarch64-linux";
    hostname = "piso";

    hardwareModules = [
      "${inputs.nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
      inputs.nixos-hardware.nixosModules.raspberry-pi-3
      ../homepi/hardware-configuration.nix
    ];

    profileModules = [
      ./configuration.nix
    ];
  };
}
