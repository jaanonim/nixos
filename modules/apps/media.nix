{pkgs, ...}: {
  my._packages = with pkgs; [
    gimp
    # blender
    obs-studio
  ];
}
