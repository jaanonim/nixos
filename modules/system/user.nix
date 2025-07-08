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
}:
with lib; let
  extraSpecialArgs = {
    inherit
      inputs
      configLib
      self
      jaanonim-pkgs
      configModules
      ;
  };
  pkgsSpecialArgs =
    extraSpecialArgs
    // {
      inherit
        pkgs
        config
        lib
        ;
    };

  makeOtherSettings = paths: builtins.foldl' (rest: _pkg: rest ++ [(builtins.removeAttrs _pkg ["packages"])]) [] (makeListOfPkgsConfigs paths);
  makeListOfPkgsConfigs = paths:
    builtins.map (path:
      import (configLib.apps path) pkgsSpecialArgs)
    paths;
  makeUserPkgs = paths: builtins.foldl' (rest: _pkg: rest ++ _pkg.packages) [] (makeListOfPkgsConfigs paths);

  packages_paths = [
    /basic.nix
    /tools.nix
    /terminal.nix
    /media.nix
    /gaming.nix
    /discord.nix
    /obsidian.nix
    /gpu-screen-recorder.nix
    /syncthing.nix
    /activitywatch.nix
    /plasma.nix
    /dev.nix
    /nix_dev.nix
    # /unity_dev.nix
    # /android_dev.nix
    # /gns3.nix
    # /wireshark.nix
  ];

  cfg = config.my;
in {
  options.my = {
    mainUser = mkOption {
      type = types.str;
      default = "jaanonim";
      example = "user";
      description = "Main user username";
    };
    userPackages = mkOption {
      type = types.listOf types.path;
      default = packages_paths;
      example = [];
      description = "Main user packages";
    };
    extraUserPackages = mkOption {
      type = types.listOf types.package;
      default = [];
      description = "Main user extra packages";
    };
    extraUserGroups = mkOption {
      type = types.listOf types.str;
      default = ["wheel"];
      example = [];
      description = "Main user extra groups";
    };
    homeManager = mkEnableOption "home-manager";
  };

  imports = mkIf cfg.homeManager [inputs.home-manager.nixosModules.default];

  config = configLib.recursiveMergeAttrs ([
      {
        # sops.secrets.jaanonim-password.neededForUsers = true;

        # users.mutableUsers = false;
        users.users.${cfg.mainUser} = {
          isNormalUser = true;
          # hashedPasswordFile = config.sops.secrets.jaanonim-password.path;
          description = cfg.mainUser;
          extraGroups = extraUserGroups;
          packages = (makeUserPkgs cfg.userPackages) ++ cfg.extraUserPackages;
        };

        security.sudo.extraRules = [
          {
            users = [cfg.mainUser];
            commands = ["ALL"];
          }
        ];

        home-manager = mkIf cfg.homeManager {
          inherit extraSpecialArgs;
          backupFileExtension = "backup";
          users.${cfg.mainUser}.home = {
            username = cfg.mainUser;
            homeDirectory = "/home/${cfg.mainUser}";

            programs.home-manager.enable = true;

            useGlobalPkgs = true;
            useUserPackages = true;

            stateVersion = "23.11"; # Don't touch
          };
        };
      }
    ]
    ++ (makeOtherSettings cfg.userPackages));
}
