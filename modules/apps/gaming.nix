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
    my._packages = with pkgs; [
      prismlauncher
      heroic
    ];

    programs = {
      gamescope.enable = true;
      steam = {
        enable = true;
        extest.enable = true;
        gamescopeSession.enable = true;
      };
    };
  };
}
