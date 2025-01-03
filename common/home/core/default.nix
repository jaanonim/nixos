_: {
  imports = [
    ./git.nix
    ./terminal.nix
    ./zsh.nix
    ./sops.nix
  ];

  programs.home-manager.enable = true;
}
