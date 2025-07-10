{
  lib,
  config,
  pkgs,
  ...
} @ args:
with lib; let
  my = config.my;
  cfg = config.my.desktop;
in {
  options.my.desktop = {
    enable = mkEnableOption "desktop environment";
    xserver = mkOption {
      type = types.bool;
      default = true;
      description = "Enable xserver";
    };
    desktopEnvironment = mkOption {
      type = types.enum ["plasma"];
      default = "plasma";
      description = "Desktop environment";
    };
    displayManager = mkOption {
      type = types.enum ["wayland"];
      default = "wayland";
      description = "Window manager (wayland or x11)";
    };
    xdgPortal = {
      enable = mkEnable {
        type = types.bool;
        default = true;
        description = "Enable xdg portals";
      };
      portals = mkOption {
        type = types.listOf types.package;
        default = with pkgs; [
          kdePackages.xdg-desktop-portal-kde
          xdg-desktop-portal-gtk
        ];
        example = [];
        description = "Xdg extra portals list";
      };
    };
    xwayland = mkOption {
      type = types.bool;
      default = true;
      description = "Enable xwayland";
    };
    kdeconnect = mkOption {
      type = types.bool;
      default = true;
      description = "Enable kdeconnect";
    };
    plasmaManager = mkEnableOption "plasma manager";
  };

  imports = mkIf cfg.enable [./cursor-fix.nix];

  config =
    mkIf cfg.enable {
      services = {
        xserver = mkIf cfg.xserver {
          enable = true;
          xkb = {
            layout = my.locale.keyMap;
            variant = "";
          };
        };
      };

      programs = {
        kdeconnect.enable = cfg.kdeconnect;
        xwayland.enable = cfg.xwayland;
      };

      xdg.portal = mkIf cfg.xdgPortal {
        enable = true;
        xdgOpenUsePortal = true;
        extraPortals = cfg.portals;
        config.common.default =
          if cfg.desktopEnvironment == "plasma"
          then "kde"
          else "";
      };
    }
    // mkIf (cfg.enable && cfg.desktopEnvironment == "plasma") {
      services = {
        displayManager = {
          defaultSession = "plasma";
          plasma6.enable = true;
        };

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

      home-manager.users.${my.mainUser} = mkIf (cfg.plasmaManager && my.homeManager) import ./hm {inherit args;};
    };
}
