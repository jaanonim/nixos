{pkgs, ...}: {
  packages = with pkgs; [
    gimp
    blender
    obs-studio
  ];
}
