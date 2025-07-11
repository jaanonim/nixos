{
  lib,
  self,
  inputs,
  ...
}: {
  flakePart.nixosConfigurations.laptop = lib.makeConfig {
    osConfig = self.nixosConfigurations.laptop.config;

    system = "x86_64-linux";
    hardwareModules = [
      inputs.nixos-hardware.nixosModules.lenovo-ideapad-15ach6
      ./hardware-configuration.nix
    ];
    profileModules = [
      ./configuration.nix
    ];
  };
}
