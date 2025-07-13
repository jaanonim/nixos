{
  lib,
  self,
  ...
}: {
  flakePart.nixosConfigurations.minimal = lib.makeConfig {
    osConfig = self.nixosConfigurations.minimal.config;

    system = "x86_64-linux";
    hardwareModules = [];
    profileModules = [
      ./configuration.nix
    ];
  };
}
