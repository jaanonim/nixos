{
  inputs,
  pkgs,
  configLib,
  self,
  jaanonim-pkgs,
  ...
}: let
  makeOtherSettings = paths: builtins.foldl' (rest: _pkg: rest ++ [(builtins.removeAttrs _pkg ["packages"])]) [] (makeListOfPkgsConfigs paths);
  makeListOfPkgsConfigs = paths: builtins.map (path: import (configLib.apps path) {inherit pkgs configLib jaanonim-pkgs;}) paths;
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
    /replay-sorcery.nix
    /syncthing.nix
    /activitywatch.nix
    /nix_dev.nix
    /plasma.nix
  ];
in {
  imports = [inputs.home-manager.nixosModules.default];

  config = configLib.recursiveMergeAttrs ([
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
      }
    ]
    ++ (makeOtherSettings packages_paths));
}
