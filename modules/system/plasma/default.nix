{
  lib,
  config,
  pkgs,
  ...
} @ args:
with lib; let
  my = config.my;
  cfg = config.my.desktop.plasma;
in {
  options.my.desktop.plasma = {
    enable = mkEnableOption "plasma";
    plasmaManager = mkEnableOption "plasma manager";
  };

  imports = [./cursor-fix.nix];

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
      xwaylandvideobridge
      konsole
    ];

    home-manager.users.${my.mainUser} = mkIf (cfg.plasmaManager && my.homeManager) (import ./hm args);
  };
}
