{
  inputs,
  system ? "",
  ...
}: let
  pkgs = import inputs.nixpkgs {inherit system;};
  inherit (inputs.nixpkgs) lib;
in rec {
  root = path: ../. + path;

  recursiveMergeAttrs = listOfAttrsets: lib.fold (attrset: acc: lib.recursiveUpdate attrset acc) {} listOfAttrsets;
  kdeFormatConfig = import ./kde-format-config.nix {inherit lib;};
  kdeColorScheme = import ./kde-color-scheme.nix {inherit lib pkgs kdeFormatConfig;};
  makeDesktopIcon = pkgs.callPackage ./make-desktop-icon.nix {};
  makeConfig = import ./make-config.nix {inherit inputs lib;};
}
