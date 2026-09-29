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
      emote
      pika-backup
      gramps
    ];

    # For pika-backup to work properly, gvfs must be enabled, otherwise it will fail to mount remote locations like smb://
    services.gvfs.enable = true;
  };
}
