_: {
  virtualisation.docker = {
    enable = true;
    enableNvidia = true;
    autoPrune.enable = true;
  };
  users.extraGroups.docker.members = ["jaanonim"];
  hardware.nvidia-container-toolkit.enable = true;

  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = ["jaanonim"];
}
