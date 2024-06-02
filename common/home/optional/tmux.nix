{pkgs, ...}: let
  inherit (pkgs) fetchFromGitHub;
  inherit (pkgs.tmuxPlugins) mkTmuxPlugin;
  tmux-power = mkTmuxPlugin {
    pluginName = "tmux-power";
    version = "1.0";
    src = fetchFromGitHub {
      owner = "wfxr";
      repo = "tmux-power";
      rev = "16bbde801378a70512059541d104c5ae35be32b9";
      hash = "sha256-IyYQyIONMnVBwhhcI3anOPxKpv2TfI2KZgJ5o5JtZ8I=";
    };
  };
in {
  programs.tmux = {
    enable = true;
    mouse = true;
    clock24 = true;
    baseIndex = 1;
    keyMode = "vi";
    terminal = "screen-256color";

    plugins = with pkgs; [
      tmuxPlugins.sensible
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
