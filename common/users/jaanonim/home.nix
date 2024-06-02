{...}: {
  imports = [
    ../../home/core
    ../../home/optional/tmux.nix
    "${fetchTarball "https://github.com/msteen/nixos-vscode-server/tarball/master"}/modules/vscode-server/home.nix"
  ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "jaanonim";
  home.homeDirectory = "/home/jaanonim";

  home.stateVersion = "23.11"; # Don't touch
}
