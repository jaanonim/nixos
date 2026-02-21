{
  lib,
  self,
  inputs,
  ...
}: {
  flakePart = lib.makeHost {
    inherit self;
    deploy = true;
    system = "aarch64-linux";
    hostname = "homepi";
    fastConnection = true;

    hardwareModules = [
      inputs.nixos-hardware.nixosModules.raspberry-pi-3
      ./hardware-configuration.nix
    ];

    profileModules = [
      ./configuration.nix
    ];
  };
}
