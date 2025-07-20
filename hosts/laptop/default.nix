{
  lib,
  self,
  inputs,
  ...
}: {
  flakePart = lib.makeHost {
    inherit self;
    system = "x86_64-linux";
    hostname = "laptop";

    hardwareModules = [
      inputs.nixos-hardware.nixosModules.lenovo-ideapad-15ach6
      ./hardware-configuration.nix
    ];
    profileModules = [
      ./configuration.nix
    ];
  };
}
