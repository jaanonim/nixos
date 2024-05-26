{
  inputs,
  lib,
  ...
}: {
  root = path: ../. + path;
  core = ../hosts/common/core;
  optional = path: ../hosts/common/optional + path;
  users = path: ../hosts/common/users + path;
  apps = path: ../hosts/common/optional/apps + path;
}
