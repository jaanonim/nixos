{configLib, ...}: {
  imports = [
    configLib.home_core
    (configLib.home_optional /tmux.nix)
    (configLib.home_optional /plasma.nix)
    (configLib.home_optional /wakatime.nix)
    "${fetchTarball "https://github.com/msteen/nixos-vscode-server/tarball/master"}/modules/vscode-server/home.nix"
  ];

  home.file.".config/fontconfig/conf.d/56-kubuntu-noto.conf".source = configLib.root /config/56-kubuntu-noto.conf; # fix for font in plasma

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home = {
    username = "jaanonim";
    homeDirectory = "/home/jaanonim";
    stateVersion = "23.11"; # Don't touch
  };
}
