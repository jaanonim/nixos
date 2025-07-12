{
  inputs,
  self,
  config,
  lib,
  ...
}:
with lib; let
  extraSpecialArgs = {
    inherit inputs self jaanonim-pkgs;
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
      default = "/home/${cfg.mainUser}";
      example = "/home/user";
      description = "Main user home directory";
    };
    extraUserGroups = mkOption {
      type = types.listOf types.str;
      default = ["wheel"];
      example = [];
      description = "Main user extra groups";
    };
    homeManager = mkEnableOption "home-manager";
  };

  imports = [inputs.home-manager.nixosModules.default];

  config = {
    users.users.${cfg.mainUser} = {
      isNormalUser = true;
      description = cfg.mainUser;
      extraGroups = cfg.extraUserGroups;
      home = cfg.homeDirectory;
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

      useGlobalPkgs = true;
      useUserPackages = true;

      users.${cfg.mainUser} = {
        programs.home-manager.enable = true;

        home = {
          username = cfg.mainUser;
          homeDirectory = cfg.homeDirectory;

          stateVersion = "23.11"; # Don't touch
        };
      };
    };
  };
}
