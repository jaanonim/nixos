{
  inputs,
  lib,
  ...
}: {
  system,
  osConfig,
  baseModules ? [
    ../modules/system
  ],
  hardwareModules ? [],
  profileModules ? [],
}:
inputs.nixpkgs.lib.nixosSystem rec {
  inherit system;
  pkgs = import inputs.nixpkgs {
    inherit system;
    overlays = builtins.attrValues (import ../overlays {inherit inputs;});
    config = {
      allowUnfree = osConfig.my.nix.allowUnfree;
      cudaSupport = osConfig.my.nix.cuda;
    };
  };
  modules = baseModules ++ hardwareModules ++ profileModules;
  specialArgs = {
    inherit inputs;
    # pass re-extend lib with system info
    lib = inputs.nixpkgs.lib.extend (_: _: (import ./default.nix {inherit inputs system;}));

    jaanonim-pkgs = import ../pkgs {inherit inputs lib system pkgs;};
  };
}
