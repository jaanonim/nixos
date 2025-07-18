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
    my._packages = with pkgs; [ghostty];

    home-manager.users.${my.mainUser}.programs.ghostty = mkIf my.homeManager {
      enable = true;
      enableZshIntegration = true;
      settings = {
        cursor-style = "block";
        cursor-style-blink = false;
        shell-integration-features = "no-cursor";
        background-opacity = 0.5;
        background-blur = true;
        working-directory = "${my.homeDirectory}/Pobrane";
      };
    };
  };
}
