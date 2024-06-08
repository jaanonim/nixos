{pkgs, ...}: {
  packages = with pkgs; [
    fzf
    vim
    wget
    git
    tmux
    tldr
    zoxide
    zsh-autosuggestions
    zsh-powerlevel10k
    imagemagick
    ffmpeg_7
  ];
}