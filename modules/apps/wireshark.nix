{pkgs, ...}: {
  packages = with pkgs; [
    wireshark
  ];

  programs.wireshark.enable = true;
  users.extraGroups.wireshark.members = ["jaanonim"];
}
