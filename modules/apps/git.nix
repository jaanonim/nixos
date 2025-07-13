{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  my = config.my;
in {
  config = mkIf (builtins.any (ele: (ele == (lib.removeSuffix ".nix" (baseNameOf __curPos.file)))) my.apps) {
    my._packages = with pkgs; [git];

    programs.git = {
      enable = true;
      lfs.enable = true;
    };

    home-manager.users.${my.mainUser} = mkIf my.homeManager {
      programs.git = {
        enable = true;
        userName = "jaanonim";
        userEmail = "mat8mro@gmail.com";
        extraConfig = {
          init.defaultBranch = "main";
          core.autocrlf = "input";
          github.user = "jaanonim";
        };
        signing = {
          signByDefault = true;
          key = "933AF32D3ABD5CAF";
        };
      };
      programs.gpg = {
        enable = true;
      };
    };
  };
}
