{
  lib,
  config,
  ...
}:
with lib; let
  inherit (config) my;
  cfg = my.docker;
in {
  options.my.docker = {
    enable = mkEnableOption "Docker";
    nvidia = mkOption {
      type = types.bool;
      default = true;
      description = "Nvidia container toolkit";
    };
  };

  config = mkIf cfg.enable {
    virtualisation.docker = {
      enable = false;

      rootless = {
        enable = true;
        setSocketVariable = true;
        daemon.settings.features.cdi = cfg.nvidia;
      };
    };
    hardware.nvidia-container-toolkit.enable = cfg.nvidia;
  };
}
