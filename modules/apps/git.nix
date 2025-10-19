{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  inherit (config) my;
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
        settings = {
          user = {
            name = "jaanonim";
            email = "mat8mro@gmail.com";
          };
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
