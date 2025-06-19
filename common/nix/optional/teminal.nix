{pkgs, ...}: let
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
  environment.defaultPackages = with pkgs; [
    ghostty
  ];

  programs = {
    zsh = {
      enable = true;
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;
      promptInit = ''
        [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
        source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      '';
    };

    tmux = {
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
