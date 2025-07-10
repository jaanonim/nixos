{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  tmux-power = pkgs.tmuxPlugins.mkTmuxPlugin {
    pluginName = "tmux-power";
    version = "1.0";
    rtpFilePath = "tmux-power.tmux";
    src = pkgs.fetchFromGitHub {
      owner = "wfxr";
      repo = "tmux-power";
      rev = "16bbde801378a70512059541d104c5ae35be32b9";
      hash = "sha256-IyYQyIONMnVBwhhcI3anOPxKpv2TfI2KZgJ5o5JtZ8I=";
    };
  };
  my = config.my;
in {
  my._packages = with pkgs; [tmux];

  programs.tmux = {
    enable = true;
    baseIndex = 1;
    plugins = [pkgs.tmuxPlugins.sensible tmux-power];
  };

  home-manager.users.${my.mainUser}.programs.tmux = mkIf my.homeManager {
    enable = true;
    mouse = true;
    clock24 = true;
    baseIndex = 1;
    keyMode = "vi";
    terminal = "screen-256color";

    plugins = [
      pkgs.tmuxPlugins.sensible
      {
        plugin = tmux-power;
        extraConfig = ''
          set -g @tmux_power_session_icon "#{?window_zoomed_flag,,}"
          set -g @tmux_power_theme "#{?client_prefix,#3DAEE9,#1D99F3}"
        '';
      }
    ];

    extraConfig = ''
      set -as terminal-features ',xterm-256color:clipboard'
      set -g renumber-windows on
    '';
  };
}
