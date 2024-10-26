{pkgs, ...}: {
  packages = with pkgs; [
    android-studio
  ];
  programs.adb.enable = true;
  users.users.jaanonim.extraGroups = ["adbusers"];
}
