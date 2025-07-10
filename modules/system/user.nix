{
  inputs,
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
  cfg = config.my;
in {
  options.my = {
    mainUser = mkOption {
      type = types.str;
      default = "jaanonim";
      example = "user";
      description = "Main user username";
    };
    homeDirectory = mkOption {
      type = types.str;
      default = "/home/${mainUser}";
      example = "/home/user";
      description = "Main user home directory";
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

  config = {
    # sops.secrets.jaanonim-password.neededForUsers = true;

    # users.mutableUsers = false;
    users.users.${cfg.mainUser} = {
      isNormalUser = true;
      # hashedPasswordFile = config.sops.secrets.jaanonim-password.path;
      description = cfg.mainUser;
      extraGroups = extraUserGroups;
      packages = cfg._packages ++ cfg.extraUserPackages;
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
        homeDirectory = cfg.homeDirectory;

        programs.home-manager.enable = true;

        useGlobalPkgs = true;
        useUserPackages = true;

        stateVersion = "23.11"; # Don't touch
      };
    };
  };
}
