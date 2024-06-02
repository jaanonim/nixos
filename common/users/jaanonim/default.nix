{
  inputs,
  pkgs,
  configLib,
  ...
}: let
  inherit (pkgs.lib.lists) foldl;
  makeUserPkgs = foldl (rest: path: rest ++ (import (configLib.apps path) pkgs)) [];
in {
  imports = [inputs.home-manager.nixosModules.default];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.jaanonim = {
    isNormalUser = true;
    description = "jaanonim";
    extraGroups = ["networkmanager" "wheel" "docker"];
    packages = makeUserPkgs [/basic.nix /dev.nix /tools.nix /terminal.nix /media.nix /gaming.nix];
  };

  home-manager = {
    extraSpecialArgs = {inherit inputs;};
    users = {"jaanonim" = import ./home.nix;};
  };
}
