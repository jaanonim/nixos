{
  lib,
  config,
  ...
}:
with lib; let
  inherit (config) my;
in {
  options.my = {
    crossCompileSystems = mkOption {
      type = types.listOf types.str;
      description = "List of arch for cross compilation on this machine.";
      example = ["aarch64-linux"];
      default = [];
    };
  };

  config = mkIf ((builtins.length my.crossCompileSystems) > 0) {
    boot.binfmt.emulatedSystems = my.crossCompileSystems;
  };
}
