{
  inputs,
  self,
  config,
  lib,
  jaanonim-pkgs,
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
    mainUserPassword = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "password";
      description = "Don't set this is unsafe. Just for testing.";
    };
    homeManager = mkEnableOption "home-manager";
  };

  config = {
    users.users.${cfg.mainUser} = {
      isNormalUser = true;
      description = cfg.mainUser;
      extraGroups = cfg.extraUserGroups;
      home = cfg.homeDirectory;
      password = cfg.mainUserPassword;
    };

    security.sudo.extraRules = [
      {
        users = [cfg.mainUser];
        commands = ["ALL"];
      }
    ];

    home-manager = mkMerge [
      (mkIf cfg.homeManager {
        inherit extraSpecialArgs;
        backupFileExtension = "backup";

        useGlobalPkgs = true;
        useUserPackages = true;

        users.${cfg.mainUser} = {
          programs.home-manager.enable = true;

          home = {
            username = cfg.mainUser;
            inherit (cfg) homeDirectory;
          };
        };
      })
      {
        users.${cfg.mainUser}.home.stateVersion = "23.11"; # Don't touch
      }
    ];
  };
}
