{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.my.devices;
in {
  options.my.devices = {
    printer = mkEnableOption "printer";
    touchpad = mkEnableOption "touchpad";
    tablet = mkEnableOption "tablet";
  };

  config = {
    services = {
      printing = mkIf cfg.printer {
        enable = true;
        drivers = [pkgs.brlaser pkgs.hplip];
      };

      avahi = mkIf cfg.printer {
        enable = true;
        nssmdns4 = true;
        openFirewall = true;
      };

      libinput.enable = cfg.touchpad;
    };

    hardware.opentabletdriver.enable = cfg.tablet;
  };
}
