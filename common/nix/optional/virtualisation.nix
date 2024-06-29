{...}: {
  virtualisation.docker.enable = true;
  users.extraGroups.docker.members = ["jaanonim"];
  
  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = ["jaanonim"];
}
