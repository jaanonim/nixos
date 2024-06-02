{...}: {
  imports = [./git.nix ./terminal.nix]; #./zsh.nix];

  programs.home-manager.enable = true;
}
