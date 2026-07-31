{
  lib,
  self,
  ...
}: {
  flakePart = lib.makeHost {
    inherit self;
    deploy = true;
    system = "x86_64-linux";
    hostname = "nas";

    hardwareModules = [
      ./hardware-configuration.nix
    ];

    profileModules = [
      ./configuration.nix
    ];
  };
}
