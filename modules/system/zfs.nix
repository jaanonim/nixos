{
  lib,
  config,
  ...
}:
with lib; let
  inherit (config) my;
in {
  options.my.zfs = {
    enable = mkEnableOption "Enable ZFS support";
    pools = mkOption {
      type = types.listOf types.str;
      default = [];
      example = ["data"];
      description = "List of ZFS pools to be imported at boot time";
    };
  };

  config = mkIf my.zfs.enable {
    boot = {
      supportedFilesystems = ["zfs"];
      zfs = {
        forceImportRoot = false;
        extraPools = my.zfs.pools;
      };
    };

    services.zfs = {
      trim.enable = true;
      autoScrub.enable = true;
    };
  };
}
