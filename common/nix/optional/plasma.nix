{pkgs, ...}: {
  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };
  services.desktopManager.plasma6.enable = true;

  services.displayManager.defaultSession = "plasma";
  programs.dconf.enable = true;

  xdg.portal.enable = true;

  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    elisa
  ];

  programs.kdeconnect.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "pl";
    variant = "";
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;
}
