{pkgs, ...}: {
  packages = with pkgs; [
    kdePackages.kate
    kdePackages.ark
    kdePackages.okular
    kdePackages.gwenview
    vlc
    libvlc
    brave
    gnome-calculator
    youtube-music
    signal-desktop
  ];
  programs.chromium.extraOpts.IncognitoModeAvailability = 1;
}
