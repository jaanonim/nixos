{
  lib,
  config,
  ...
}:
with lib; let
  inherit (config) my;
  cfg = config.my.desktop;
in {
  options.my.desktop = {
    enable = mkEnableOption "desktop environment";
    xserver = mkOption {
      type = types.bool;
      default = false;
      example = true;
      description = "Enable xserver";
    };
    defaultDesktop = mkOption {
      type = types.enum ["plasma"];
      default = "plasma";
      description = "default desktop";
    };
    displayManager = mkOption {
      type = types.enum ["wayland"];
      default = "wayland";
      description = "Window manager (wayland or x11)";
    };
    xdgPortal = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable xdg portals";
      };
      portals = mkOption {
        type = types.listOf types.package;
        default = [];
        example = lib.literalExpression ''with pkgs; [ kdePackages.xdg-desktop-portal-kde xdg-desktop-portal-gtk ]'';
        description = "Xdg extra portals list";
      };
    };
    xwayland = mkOption {
      type = types.bool;
      default = false;
      example = true;
      description = "Enable xwayland";
    };
    kdeconnect = mkOption {
      type = types.bool;
      default = true;
      description = "Enable kdeconnect";
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.defaultDesktop == "plasma" -> cfg.plasma.enable;
        message = "plasma need to be enabled to be default desktop";
      }
      {
        assertion = cfg.xwayland -> cfg.xserver;
        message = "xserver need to be enabled to use xwayland";
      }
    ];

    services = {
      xserver = mkIf cfg.xserver {
        enable = true;
        xkb = {
          layout = my.locale.keyMap;
          variant = "";
        };
      };

      displayManager.defaultSession = cfg.defaultDesktop;
    };

    programs = {
      kdeconnect.enable = cfg.kdeconnect;
      xwayland.enable = cfg.xwayland;
    };

    xdg.portal = mkIf cfg.xdgPortal.enable {
      enable = true;
      xdgOpenUsePortal = true;
      extraPortals = cfg.xdgPortal.portals;
      config.common.default =
        if cfg.defaultDesktop == "plasma"
        then "kde"
        else "";
    };
  };
}
