{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.my.audio;
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
        drivers = [pkgs.brlaser];
      };
      libinput.enable = cfg.touchpad;
    };

    hardware.opentabletdriver.enable = cfg.tablet;
  };
}
