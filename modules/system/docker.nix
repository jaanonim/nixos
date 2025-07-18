{
  lib,
  config,
  ...
}:
with lib; let
  inherit (config) my;
  cfg = config.my.docker;
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
      enable = true;
      enableOnBoot = false;
      autoPrune.enable = true;
    };
    users.extraGroups.docker.members = [my.mainUser];
    hardware.nvidia-container-toolkit.enable = cfg.nvidia;
  };
}
