_: {
  virtualisation.docker = {
    enable = true;
    enableOnBoot = false;
    autoPrune.enable = true;
  };
  users.extraGroups.docker.members = ["jaanonim"];
  hardware.nvidia-container-toolkit.enable = true;
}
