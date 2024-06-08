{pkgs, ...}: {
  packages = with pkgs; [
    kdePackages.kate
    kdePackages.ark
    kdePackages.okular
    kdePackages.gwenview
    vlc
    brave
    discord
    gnome.gnome-calculator
  ];
}