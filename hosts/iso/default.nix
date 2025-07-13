{
  lib,
  self,
  ...
}: {
  flakePart.nixosConfigurations.iso = lib.makeConfig {
    osConfig = self.nixosConfigurations.iso.config;

    system = "x86_64-linux";
    hardwareModules = [];
    profileModules = [
      ./configuration.nix
    ];
  };
}
