{
  lib,
  self,
  ...
}: {
  flakePart = lib.makeHost {
    inherit self;
    system = "x86_64-linux";
    hostname = "minimal";

    hardwareModules = [];
    profileModules = [
      ./configuration.nix
    ];
  };
}
