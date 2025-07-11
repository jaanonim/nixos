{inputs, ...}: let
  inherit (inputs.nixpkgs) lib;
in {
  root = path: ../. + path;

  recursiveMergeAttrs = listOfAttrsets: lib.fold (attrset: acc: lib.recursiveUpdate attrset acc) {} listOfAttrsets;
  kdeFormatConfig = import ./kde-format-config.nix {inherit lib;};
  kdeColorScheme = import ./kde-color-scheme.nix {
    inherit lib;
    pkgs = inputs.nixpkgs;
  };
  makeDesktopIcon = inputs.nixpkgs.callPackage ./make-desktop-icon.nix {};
  makeConfig = import ./make-config.nix {inherit inputs lib;};
}
