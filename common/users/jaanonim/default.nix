{
  inputs,
  pkgs,
  configLib,
  ...
}: let
  makeOtherSettings = paths: builtins.foldl' (rest: _pkg: rest // builtins.removeAttrs _pkg ["packages"]) {} (makeListOfPkgsConfigs paths);
  makeListOfPkgsConfigs = paths: builtins.map (path: import (configLib.apps path) {inherit pkgs;}) paths;
  makeUserPkgs = paths: builtins.foldl' (rest: _pkg: rest ++ _pkg.packages) [] (makeListOfPkgsConfigs paths);
  packages_paths = [/basic.nix /dev.nix /tools.nix /terminal.nix /media.nix /gaming.nix /discord.nix];
in {
  imports = [inputs.home-manager.nixosModules.default];

  config =
    {
      # Define a user account. Don't forget to set a password with ‘passwd’.
      users.users.jaanonim = {
        isNormalUser = true;
        description = "jaanonim";
        extraGroups = ["networkmanager" "wheel" "docker"];
        packages = makeUserPkgs packages_paths;
      };

      home-manager = {
        extraSpecialArgs = {inherit inputs configLib;};
        users = {"jaanonim" = import ./home.nix;};
      };
    }
    // (makeOtherSettings packages_paths);
}
