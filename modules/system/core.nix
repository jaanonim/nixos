{lib, ...}:
with lib; {
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
