{pkgs, ...}: {
  # Replay-sorcery is ded, and don't work at this moment - need to find better replacement for that may be https://wiki.nixos.org/wiki/Gpu-screen-recorder
  packages = with pkgs; [];
  # packages = with pkgs; [
  #   replay-sorcery
  # ];

  # services.replay-sorcery = {
  #   enable = true;
  #   autoStart = true;
  #   enableSysAdminCapability = true;
  #   settings = {
  #     videoInput = "hwaccel";
  #     videoFramerate = 30;
  #   };
  # };
}
