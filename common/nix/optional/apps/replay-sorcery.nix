{pkgs, ...}: {
  # Replay-sorcery is ded, and don't work at this moment - need to find better replacement for that

  packages = with pkgs; [
    replay-sorcery
  ];

  services.replay-sorcery = {
    enable = true;
    autoStart = true;
    enableSysAdminCapability = true;
    settings = {
      videoInput = "hwaccel";
      videoFramerate = 30;
    };
  };
}
