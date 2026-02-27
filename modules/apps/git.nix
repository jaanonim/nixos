{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  inherit (config) my;
  gitPkg = pkgs.gitFull;
in {
  config = mkIf (builtins.any (ele: (ele == (lib.removeSuffix ".nix" (baseNameOf __curPos.file)))) my.apps) {
    programs.git = {
      enable = true;
      package = gitPkg;
      lfs.enable = true;
    };

    home-manager.users.${my.mainUser} = mkIf my.homeManager {
      programs.git = {
        enable = true;
        package = gitPkg;
        settings = {
          user = {
            name = "jaanonim";
            email = "mat8mro@gmail.com";
          };
          init.defaultBranch = "main";
          core.autocrlf = "input";
          github.user = "jaanonim";
          credential.helper = "libsecret";
        };
        signing = {
          signByDefault = true;
          key = "933AF32D3ABD5CAF";
        };
        ignores = [
          ".envrc"
          ".direnv/"
        ];
      };
      programs.gpg = {
        enable = true;
      };
    };
  };
}
