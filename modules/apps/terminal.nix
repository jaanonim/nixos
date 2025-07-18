{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  inherit (config) my;
in {
  config = mkIf (builtins.any (ele: (ele == (lib.removeSuffix ".nix" (baseNameOf __curPos.file)))) my.apps) {
    my._packages = with pkgs; [
      fzf
      vim
      wget
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

    home-manager.users.${my.mainUser}.programs = mkIf my.homeManager {
      zoxide = {
        enable = true;
        enableZshIntegration = true;
        options = ["--cmd cd"];
      };
      vim = {
        enable = true;
        settings = {
          number = true;
        };
      };
      direnv = {
        enable = true;
        config = {
          hide_env_diff = true;
        };
        enableZshIntegration = true;
        nix-direnv.enable = true;
      };
    };
  };
}
