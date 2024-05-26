{
  config,
  pkgs,
  inputs,
  ...
}: let
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
  # imports = [./plasma.nix];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "jaanonim";
  home.homeDirectory = "/home/jaanonim";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  programs = {
    zsh = {
      enable = true;
      history = {
        size = 10000000;
        save = 10000000;
        ignoreDups = true;
        ignoreAllDups = true;
        expireDuplicatesFirst = true;
        extended = true;
        share = true;
      };
      plugins = [
        {
          name = "zsh-nix-shell";
          file = "nix-shell.plugin.zsh";
          src = pkgs.fetchFromGitHub {
            owner = "chisui";
            repo = "zsh-nix-shell";
            rev = "v0.8.0";
            sha256 = "1lzrn0n4fxfcgg65v0qhnj7wnybybqzs4adz7xsrkgmcsr0ii8b7";
          };
        }
      ];
      oh-my-zsh = {
        enable = true;
        plugins = ["git" "rust" "python" "sudo" "fzf"];
      };
    };
    zoxide = {
      enable = true;
      enableZshIntegration = true;
      options = ["--cmd cd"];
    };
    tmux = {
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
    git = {
      enable = true;
      userName = "jaanonim";
      userEmail = "mat8mro@gmail.com";
      extraConfig = {
        init.defaultBranch = "main";
        core.autocrlf = "input";
      };
    };
    vim = {
      enable = true;
      settings = {
        number = true;
      };
    };
  };

  home.file.".p10k.zsh" = {
    source = inputs.self + /config/.p10k.zsh;
    executable = true;
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/jaanonim/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
