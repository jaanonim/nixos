{
  lib,
  config,
  ...
}:
with lib; let
  inherit (config) my;
  cfg = config.my.virtualbox;
in {
  options.my.virtualbox = {
    enable = mkEnableOption "virtualbox program";
  };

  config = mkIf cfg.enable {
    virtualisation.virtualbox.host.enable = true;
    users.extraGroups.vboxusers.members = [my.mainUser];
    boot.kernelParams = ["kvm.enable_virt_at_load=0"];
  };
}
