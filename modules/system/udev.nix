{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.my.udev;
  udevRules = {
    attiny85 = ''
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="16d0", ATTRS{idProduct}=="0753", MODE:="0666"
      KERNEL=="ttyACM*", ATTRS{idVendor}=="16d0", ATTRS{idProduct}=="0753", MODE:="0666", ENV{ID_MM_DEVICE_IGNORE}="1"
    '';
    esp32 = ''
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="10c4", ATTRS{idProduct}=="ea60", MODE="0666"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1a86", ATTRS{idProduct}=="55d3", MODE="0666"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="303a", ATTRS{idProduct}=="1001", MODE="0666"
    '';
  };
in {
  options.my.udev = {
    enable = mkEnableOption "Extra udev rules";
    probe-rs = mkOption {
      type = types.bool;
      example = false;
      default = true;
      description = "Whether to enable udev rules for rs-probe";
    };
    rules = mkOption {
      type = types.listOf (types.enum (builtins.attrNames udevRules));
      example = ["esp32"];
      default = builtins.attrNames udevRules;
      description = "For witch devices to enable udev rules";
    };
  };

  config = mkIf cfg.enable {
    hardware.probe-rs.enable = cfg.probe-rs;
    services.udev.extraRules = builtins.concatStringsSep "\n" (builtins.map (name: udevRules.${name}) cfg.rules);
  };
}
