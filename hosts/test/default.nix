{
  lib,
  self,
  ...
}: {
  flakePart.nixosConfigurations.test = lib.makeConfig {
    osConfig = self.nixosConfigurations.test.config;

    system = "x86_64-linux";
    hardwareModules = [];
    profileModules = [
      ./configuration.nix
    ];
  };
}
