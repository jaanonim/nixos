{
  lib,
  pkgs,
  ...
}: rec {
  root = path: ../. + path;

  core = ../common/nix/core;
  some_core = path: ../common/nix/core + path;
  optional = path: ../common/nix/optional + path;
  apps = path: ../common/nix/optional/apps + path;

  users = path: ../common/users + path;

  home_core = ../common/home/core;
  home_optional = path: ../common/home/optional + path;
  pkgs_utils = path: ../pkgs/utils + path;
  get_util = name: args: (
    import (pkgs_utils "/${name}.nix") args
  );

  recursiveMergeAttrs = listOfAttrsets: lib.fold (attrset: acc: lib.recursiveUpdate attrset acc) {} listOfAttrsets;
  kdeFormatConfig = import ./kde-format-config.nix {inherit lib;};
  makeDesktopIcon = pkgs.callPackage ./make-desktop-icon.nix {};
}
