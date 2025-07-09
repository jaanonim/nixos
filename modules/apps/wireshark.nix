{
  pkgs,
  config,
  ...
}: let
  my = config.my;
in {
  packages = with pkgs; [wireshark];

  programs.wireshark.enable = true;
  users.extraGroups.wireshark.members = [my.mainUser];
}
