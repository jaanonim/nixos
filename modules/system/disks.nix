{
  lib,
  config,
  ...
}:
with lib; let
  inherit (config) my;
in {
  options.my = {
    disks = mkOption {
      type = types.attrsOf types.str;
      default = {};
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
