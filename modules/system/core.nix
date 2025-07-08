{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.my;
in {
  options.my = {
    hostname = mkOption {
      type = types.str;
      default = "Laptop";
      description = "Hostname for machine";
    };
  };

  config = {
    hardware.enableRedistributableFirmware = true;
  };
}
