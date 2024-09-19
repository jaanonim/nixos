{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.myConfig.displayServer;
  wayland = cfg == "wayland";
  x11 = cfg == "x11";
in {
  options.myConfig.displayServer = lib.mkOption {
    default = "x11";
    type = lib.types.enum ["x11" "wayland"];
    description = "The display server to use";
  };

  config = {
    services = {
      xserver.enable = x11;

      desktopManager.plasma6.enable = true;

      displayManager = {
        sddm = {
          enable = true;
          enableHidpi = false;
          autoNumlock = true;
          wayland.enable = wayland;
        };
        defaultSession =
          if wayland
          then "plasma"
          else "plasmax11";
      };
    };

    programs = {
      dconf.enable = true;
      kdeconnect.enable = true;
      xwayland.enable = wayland;
    };

    xdg.portal = lib.mkIf wayland {
      enable = true;
      xdgOpenUsePortal = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-kde
      ];
    };

    environment.systemPackages = lib.mkIf wayland [
      pkgs.xwaylandvideobridge
    ];

    environment.plasma6.excludePackages = with pkgs.kdePackages; [
      elisa
      krdp
    ];

    # Configure keymap in X11
    services.xserver.xkb = {
      layout = "pl";
      variant = "";
    };

    # Enable touchpad support (enabled default in most desktopManager).
    services.libinput.enable = true;
  };
}
