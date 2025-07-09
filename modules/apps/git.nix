{
  config,
  lib,
  ...
}:
with lib; let
  my = config.my;
in {
  packages = with pkgs; [git];

  programs.git = {
    enable = true;
    lfs.enable = true;
  };

  home-manager.users.${my.mainUser}.programs.git = mkIf my.mainUser {
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
}
