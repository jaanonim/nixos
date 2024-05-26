{
  config,
  pkgs,
  inputs,
  configLib,
  ...
}: let
  inherit (pkgs.lib.lists) foldl;
  makeUserPkgs = foldl (rest: path: rest ++ (import (configLib.apps path) pkgs)) [];
in {
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.jaanonim = {
    isNormalUser = true;
    description = "jaanonim";
    extraGroups = ["networkmanager" "wheel" "docker"];
    packages = makeUserPkgs [/basic.nix /dev.nix /tools.nix /terminal.nix /media.nix /gaming.nix];
  };
}
