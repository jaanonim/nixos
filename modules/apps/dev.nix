{
  pkgs,
  config,
  lib,
  jaanonim-pkgs,
  ...
}:
with lib; let
  inherit (config) my;
in {
  config = mkIf (builtins.any (ele: (ele == (lib.removeSuffix ".nix" (baseNameOf __curPos.file)))) my.apps) {
    my._packages = with pkgs;
      [
        # jetbrains.clion
        jetbrains.pycharm-professional
        # jetbrains.idea-ultimate
        # jetbrains.goland
        vscode
      ]
      ++ (with jaanonim-pkgs; [creator forklab]);
  };
}
