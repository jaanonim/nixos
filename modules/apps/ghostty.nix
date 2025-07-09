{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  my = config.my;
in {
  packages = with pkgs; [ghostty];

  home-manager.users.${my.mainUser}.programs.ghostty = mkIf my.homeManager {
    enable = true;
    enableZshIntegration = true;
    settings = {
      cursor-style = "block";
      cursor-style-blink = false;
      shell-integration-features = "no-cursor";
      background-opacity = 0.5;
      background-blur = true;
      working-directory = "/home/jaanonim/Pobrane";
    };
  };
}
