{
  inputs,
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  inherit (config) my;
  localPkgs = import inputs.nixpkgs {
    inherit (pkgs) system;
    config = {
      allowUnfree = true;
      permittedInsecurePackages = [
        "firefox-esr-140-bin-unwrapped-140.17.0esr"
      ];
    };
  };
in {
  config = mkIf (builtins.any (ele: (ele == (lib.removeSuffix ".nix" (baseNameOf __curPos.file)))) my.apps) {
    my._packages = with localPkgs; [
      zotero
    ];
  };
}
