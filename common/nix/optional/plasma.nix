{pkgs, ...}: {
  # Enable the X11 windowing system.
  services = {
    xserver.enable = true;

    # Enable the KDE Plasma Desktop Environment.
    desktopManager.plasma6.enable = true;

    displayManager = {
      sddm = {
        enable = true;
        wayland.enable = true;
      };
      defaultSession = "plasma";
    };
  };

  programs = {
    dconf.enable = true;
    xwayland.enable = true;
    kdeconnect.enable = true;
  };

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-kde
    ];
  };

  environment.systemPackages = with pkgs; [
    xwaylandvideobridge
  ];

  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    elisa
    krdp
  ];

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "pl";
    variant = "";
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;
}
