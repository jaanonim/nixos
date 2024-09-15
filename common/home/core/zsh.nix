{
  pkgs,
  configLib,
  ...
}: let
  inherit (pkgs) fetchFromGitHub;
in {
  programs.zsh = {
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
    shellAliases = {
      nd = "nix develop -c zsh";
      ns = "nix-shell -p $(nsearch)";
      ports = "lsof -i -P -n | grep LISTEN";
      nas = "ssh 192.168.1.102";
      homepi = "ssh 192.168.1.150";
    };
    plugins = [
      {
        name = "zsh-nix-shell";
        file = "nix-shell.plugin.zsh";
        src = fetchFromGitHub {
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

  home.file.".p10k.zsh" = {
    source = configLib.root /config/.p10k.zsh;
    executable = true;
  };
}
