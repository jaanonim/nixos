{pkgs, ...}: {
  packages = with pkgs; [
    fzf
    vim
    wget
    git
    tmux
    tlrc #TODO: add config to hm
    zoxide
    zsh-autosuggestions
    zsh-powerlevel10k
    imagemagick
    ffmpeg_7
    unzip
    gnugrep
    lsof
    htop
    btop
    bat
    # nvtopPackages.nvidia
  ];

  programs = {
    tmux = let
      tmux-power = pkgs.tmuxPlugins.mkTmuxPlugin {
        pluginName = "tmux-power";
        version = "1.0";
        src = pkgs.fetchFromGitHub {
          owner = "wfxr";
          repo = "tmux-power";
          rev = "16bbde801378a70512059541d104c5ae35be32b9";
          hash = "sha256-IyYQyIONMnVBwhhcI3anOPxKpv2TfI2KZgJ5o5JtZ8I=";
        };
      };
    in {
      enable = true;
      baseIndex = 1;
      plugins = [pkgs.tmuxPlugins.sensible tmux-power];
    };

    git = {
      enable = true;
      lfs.enable = true;
    };
  };
}
