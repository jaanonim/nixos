{
  lib,
  config,
  ...
}:
with lib; let
  my = config.my;
in {
  options.my = {
    disks = mkOption {
      type = types.attrsOf types.str;
      default = {
        "/mnt/dane" = "/dev/disk/by-uuid/ee53362c-cad2-4ac1-9060-02c868233572";
      };
      example = {
        "path" = "device";
      };
      description = "Mount disk partition ext4";
    };
  };

  config = {
    fileSystems =
      mapAttrs (name: value: {
        device = value;
        fsType = "ext4";
        options = ["users" "nofail" "exec"];
      })
      my.disks;
  };
}
