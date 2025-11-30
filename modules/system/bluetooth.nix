{
  lib,
  config,
  ...
}:
with lib; let
  inherit (config) my;
  cfg = config.my.bluetooth;
in {
  options.my.bluetooth = {
    enable = mkEnableOption "bluetooth";
  };

  config = mkIf cfg.enable {
    hardware.enableAllFirmware = true;
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings = {
        General = {
          Name = my.hostname;
          ControllerMode = "dual";
          FastConnectable = true;
          Experimental = true;
        };
        Policy = {
          AutoEnable = true;
        };
      };
    };
  };
}
