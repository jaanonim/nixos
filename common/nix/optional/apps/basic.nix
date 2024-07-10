{pkgs, ...}: {
  packages = with pkgs; [
    kdePackages.kate
    kdePackages.ark
    kdePackages.okular
    kdePackages.gwenview
    kdePackages.korganizer
    kdePackages.akonadi
    kdePackages.kdepim-addons
    kdePackages.kdepim-runtime
    vlc
    brave
    gnome.gnome-calculator
  ];
}
