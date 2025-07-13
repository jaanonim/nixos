{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.my.shell;
  my = config.my;
in {
  options.my.shell = {
    zsh = {
      enable = mkEnableOption "zsh as default shell";
      powerlevel10k = mkEnableOption "powerlevel10k theme";
      zshNixShell = mkEnableOption "zsh nix shell";
      ohMyZsh = {
        enable = mkEnableOption "Oh my zsh";
        plugins = mkOption {
          type = types.listOf types.str;
          default = ["git" "rust" "python" "sudo" "fzf" "man" "tldr"];
          description = "List of oh my zsh plugins";
        };
      };
    };

    aliases = mkOption {
      type = types.attrsOf types.str;
      default = {
        nd = "nix develop -c zsh";
        ns = "NIXPKGS_ALLOW_UNFREE=1 nix-shell -p $(nsearch)";
        ports = "lsof -i -P -n | grep LISTEN";
        nas = "ssh 192.168.1.102";
        homepi = "ssh 192.168.1.150";
      };
      example = {
        name = "command";
      };
      description = "Shell aliases";
    };

    historySize = mkOption {
      type = types.int;
      default = 10000000;
      description = "History size";
    };
  };

  config = mkIf cfg.zsh.enable {
    environment.shells = with pkgs; [zsh];
    users.defaultUserShell = pkgs.zsh;

    programs.zsh = {
      enable = true;
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;

      promptInit = mkIf cfg.zsh.powerlevel10k ''
        [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
        source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      '';
    };

    home-manager.users.${my.mainUser} = mkIf my.homeManager {
      programs.zsh = {
        enable = true;
        localVariables = {
          ZSH_COMPDUMP = "$HOME/.cache/zsh/zcompcache";
        };
        history = {
          size = cfg.historySize;
          save = cfg.historySize;
          ignoreDups = true;
          ignoreAllDups = true;
          expireDuplicatesFirst = true;
          extended = true;
          share = true;
        };
        shellAliases = cfg.aliases;
        plugins = mkIf cfg.zsh.zshNixShell [
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
        oh-my-zsh = mkIf cfg.zsh.ohMyZsh.enable {
          enable = true;
          plugins = cfg.zsh.ohMyZsh.plugins;
        };
      };

      home.file.".p10k.zsh" = mkIf cfg.zsh.powerlevel10k {
        source = lib.root /config/.p10k.zsh;
        executable = true;
      };
    };
  };
}
