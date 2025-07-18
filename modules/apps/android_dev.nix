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
      android-studio
    ];
    programs.adb.enable = true;
    users.extraGroups.adbusers.members = [my.mainUser];
  };
}
