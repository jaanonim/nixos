{
  lib,
  config,
  pkgs,
  ...
} @ args:
with lib; let
  inherit (config) my;
  cfg = config.my.desktop.plasma;
in {
  options.my.desktop.plasma = {
    enable = mkEnableOption "plasma";
    plasmaManager = mkEnableOption "plasma manager";
    kwallet = mkOption {
      type = types.bool;
      default = true;
      example = false;
      description = "Whether to enable kwallet for secrets store";
    };
  };

  # imports = [./cursor-fix.nix];

  config = mkIf cfg.enable {
    services = {
      desktopManager.plasma6.enable = true;

      power-profiles-daemon = {
        enable = true;
      };
    };

    programs.dconf.enable = true;

    environment.plasma6.excludePackages = with pkgs.kdePackages; [
      elisa
      krdp
      discover
      # xwaylandvideobridge
      konsole
    ];

    security.pam.services.${my.mainUser}.kwallet = mkIf cfg.kwallet {
      enable = true;
      package = pkgs.kdePackages.kwallet-pam;
    };

    home-manager.users.${my.mainUser} = mkIf (cfg.plasmaManager && my.homeManager) (import ./hm args);
  };
}
