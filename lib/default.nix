{...}: {
  root = path: ../. + path;

  core = ../common/nix/core;
  optional = path: ../common/nix/optional + path;
  apps = path: ../common/nix/optional/apps + path;

  users = path: ../common/users + path;

  home_core = ../common/home/core;
  home_optional = path: ../common/home/optional + path;
}
