_: {
  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = ["jaanonim"];
  boot.kernelParams = ["kvm.enable_virt_at_load=0"];
}
