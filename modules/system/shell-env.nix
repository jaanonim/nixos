{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  inherit (config) my;
in {
  options.my = {
    direnv.enable = mkEnableOption "direnv";
    devenv.enable = mkEnableOption "devenv";
  };

  config = mkMerge [
    (mkIf my.direnv.enable {
      environment.systemPackages = with pkgs; [direnv];

      home-manager.users.${my.mainUser}.programs = mkIf my.homeManager {
        direnv = {
          enable = true;
          config = {
            hide_env_diff = true;
          };
          enableZshIntegration = true;
          nix-direnv.enable = true;
        };
      };
    })
    (mkIf my.devenv.enable {
      environment.systemPackages = with pkgs; [devenv];

      home-manager.users.${my.mainUser}.programs = mkIf my.homeManager {
        devenv = {
          enable = true;
          enableZshIntegration = true;
        };
      };
    })
  ];
}
