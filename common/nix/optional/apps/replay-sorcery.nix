{pkgs, ...}: {
  packages = with pkgs; [
    replay-sorcery
  ];

  services.replay-sorcery = {
    enable = true;
    autoStart = true;
    # enableSysAdminCapability = true;
    settings = {
      # videoInput = "hwaccel";
      videoFramerate = 30;
    };
  };
}
