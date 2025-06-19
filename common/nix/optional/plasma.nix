{pkgs, ...}: {
  services = {
    xserver.enable = true;

    desktopManager.plasma6.enable = true;

    displayManager = {
      sddm = {
        enable = true;
        enableHidpi = false;
        autoNumlock = true;
        wayland.enable = true;
      };
      defaultSession = "plasma";
    };
  };

  programs = {
    dconf.enable = true;
    kdeconnect.enable = true;
    xwayland.enable = true;
  };

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = with pkgs; [
      kdePackages.xdg-desktop-portal-kde
      xdg-desktop-portal-gtk
    ];
    config.common.default = "kde";
  };

  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    elisa
    krdp
    discover
    xwaylandvideobridge
    konsole
  ];

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "pl";
    variant = "";
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  # Power management
  services.power-profiles-daemon.enable = true;
}
