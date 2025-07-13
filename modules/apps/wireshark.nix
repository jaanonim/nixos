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
    my._packages = with pkgs; [wireshark];

    programs.wireshark.enable = true;
    users.extraGroups.wireshark.members = [my.mainUser];
  };
}
