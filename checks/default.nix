{
  inputs,
  pkgs,
  system,
  ...
}: let
  callPackage = pkgs.lib.callPackageWith (pkgs // {inherit (inputs) self;});
in
  {
    alejandra = callPackage ./alejandra.nix {};
    statix = callPackage ./statix.nix {};
  }
  // inputs.deploy-rs.lib.${system}.deployChecks inputs.self.deploy
