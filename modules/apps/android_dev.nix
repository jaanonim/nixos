{
  pkgs,
  config,
  ...
}: let
  my = config.my;
in {
  packages = with pkgs; [
    android-studio
  ];
  programs.adb.enable = true;
  users.extraGroups.adbusers.members = [my.mainUser];
}
