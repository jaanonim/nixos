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
      (lutris.override {
        extraLibraries = pkgs: [pkgs.libunwind];
        extraPkgs = pkgs: [pkgs.python3];
      })
      prismlauncher
    ];

    programs = {
      gamescope.enable = true;
      steam = {
        enable = true;
        gamescopeSession.enable = true;
      };
    };
  };
}
