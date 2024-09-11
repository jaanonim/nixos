{
  inputs,
  pkgs,
  configLib,
  self,
  jaanonim-pkgs,
  config,
  configModules,
  lib,
  ...
}: let
  makeOtherSettings = paths: builtins.foldl' (rest: _pkg: rest ++ [(builtins.removeAttrs _pkg ["packages"])]) [] (makeListOfPkgsConfigs paths);
  makeListOfPkgsConfigs = paths:
    builtins.map (path:
      import (configLib.apps path) {
        inherit
          inputs
          pkgs
          configLib
          self
          jaanonim-pkgs
          config
          lib
          ;
      })
    paths;
  makeUserPkgs = paths: builtins.foldl' (rest: _pkg: rest ++ _pkg.packages) [] (makeListOfPkgsConfigs paths);
  packages_paths = [
    /basic.nix
    /dev.nix
    /tools.nix
    /terminal.nix
    /media.nix
    /gaming.nix
    /discord.nix
    /obsidian.nix
    /gpu-screen-recorder.nix
    /syncthing.nix
    /activitywatch.nix
    /nix_dev.nix
    /plasma.nix
  ];
in {
  imports = [inputs.home-manager.nixosModules.default];

  config = configLib.recursiveMergeAttrs ([
      {
        # sops.secrets.jaanonim-password.neededForUsers = true;

        # users.mutableUsers = false;
        users.users.jaanonim = {
          isNormalUser = true;
          # hashedPasswordFile = config.sops.secrets.jaanonim-password.path;
          description = "jaanonim";
          extraGroups = ["networkmanager" "wheel"];
          packages = makeUserPkgs packages_paths;
        };

        home-manager = {
          extraSpecialArgs = {inherit inputs configLib self configModules;};
          backupFileExtension = "backup";
          users = {"jaanonim" = import ./home.nix;};
        };
      }
    ]
    ++ (makeOtherSettings packages_paths));
}
