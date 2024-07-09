_: rec {
  root = path: ../. + path;

  core = ../common/nix/core;
  optional = path: ../common/nix/optional + path;
  apps = path: ../common/nix/optional/apps + path;

  users = path: ../common/users + path;

  home_core = ../common/home/core;
  home_optional = path: ../common/home/optional + path;
  pkgs_utils = path: ../pkgs/utils + path;
  get_util = name: args: (
    import (pkgs_utils "/${name}.nix") args
  );
}
