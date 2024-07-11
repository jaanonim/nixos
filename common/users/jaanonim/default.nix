{
  inputs,
  pkgs,
  configLib,
  self,
  ...
}: let
  makeOtherSettings = paths: builtins.foldl' (rest: _pkg: rest // builtins.removeAttrs _pkg ["packages" "autostart"]) {} (makeListOfPkgsConfigs paths);
  makeListOfPkgsConfigs = paths: builtins.map (path: import (configLib.apps path) {inherit pkgs configLib;}) paths;
  makeUserPkgs = paths: builtins.foldl' (rest: _pkg: rest ++ _pkg.packages) [] (makeListOfPkgsConfigs paths);
  makeAutostart = paths: builtins.foldl' (rest: _pkg: rest // (_pkg.autostart or {})) {} (makeListOfPkgsConfigs paths);
  packages_paths = [
    /basic.nix
    /dev.nix
    /tools.nix
    /terminal.nix
    /media.nix
    /gaming.nix
    /discord.nix
    /obsidian.nix
    /replay-sorcery.nix
    /syncthing.nix
    /activitywatch.nix
  ];
in {
  imports = [inputs.home-manager.nixosModules.default];

  config =
    {
      # Define a user account. Don't forget to set a password with ‘passwd’.
      users.users.jaanonim = {
        isNormalUser = true;
        description = "jaanonim";
        extraGroups = ["networkmanager" "wheel"];
        packages = makeUserPkgs packages_paths;
      };

      home-manager = {
        extraSpecialArgs = {inherit inputs configLib self;};
        users = {"jaanonim" = import ./home.nix;};
      };

      environment.etc = makeAutostart packages_paths;
    }
    // (makeOtherSettings packages_paths);
}
