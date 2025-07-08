{
  inputs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.my.udev;
in {
  imports = [inputs.probe-rs-rules.nixosModules.default];

  options.my.udev = {
    enable = mkEnableOption "Extra udev rules";
  };

  config = mkIf cfg.enable {
    hardware.probe-rs.enable = true;
    services.udev.extraRules = ''
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="16d0", ATTRS{idProduct}=="0753", MODE:="0666"
      KERNEL=="ttyACM*", ATTRS{idVendor}=="16d0", ATTRS{idProduct}=="0753", MODE:="0666", ENV{ID_MM_DEVICE_IGNORE}="1"
    '';
  };
}
