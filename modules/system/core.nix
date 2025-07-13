{lib, ...}:
with lib; {
  options.my = {
    hostname = mkOption {
      type = types.str;
      example = "Laptop";
      description = "Hostname for machine";
    };
  };

  config = {
    hardware.enableRedistributableFirmware = true;
  };
}
