{
  lib,
  self,
  inputs,
  ...
}: {
  flakePart.nixosConfigurations.homepi = lib.makeConfig {
    osConfig = self.nixosConfigurations.homepi.config;

    system = "aarch64-linux";
    hardwareModules = [];
    profileModules = [
      ./configuration.nix
    ];
  };
}
