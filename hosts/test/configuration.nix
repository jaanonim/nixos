{pkgs, ...}: {
  my = {
    mainUser = "jaanonim";
    homeDirectory = "/home/jaaonim";
    extraUserGroups = ["wheel"];
    hostname = "Laptop";
    setPassword = true;
    sops = true;
    homeManager = true;
    shell = {
      aliases = {
        homepi = "ssh 192.168.1.150";
        nas = "ssh 192.168.1.102";
        nd = "nix develop -c zsh";
        ns = "NIXPKGS_ALLOW_UNFREE=1 nix-shell -p $(nsearch)";
        ports = "lsof -i -P -n | grep LISTEN";
      };
      historySize = 10000000;
      zsh = {
        enable = true;
        ohMyZsh = {
          enable = true;
          plugins = ["git" "rust" "python" "sudo" "fzf" "man" "tldr"];
        };
        zshNixShell = true;
      };
    };
    apps = [
      "basic"
      "tools"
      "terminal"
    ];
    boot = {
      bootloaderTimeout = 1;
      grubConfigurationLimit = 16;
      optimize = true;
    };
    desktop = {
      enable = true;
      defaultDesktop = "plasma";
      displayManager = "wayland";
      xserver = true;
      xwayland = true;
      kdeconnect = true;

      xdgPortal = {
        enable = true;
        portals = with pkgs; [
          kdePackages.xdg-desktop-portal-kde
          xdg-desktop-portal-gtk
        ];
      };

      plasma = {
        enable = true;
        plasmaManager = false;
      };
    };
    locale = {
      keyMap = "pl";
      locale = "pl_PL.UTF-8";
      timeZone = "Europe/Warsaw";
    };
    nix = {
      allowUnfree = true;
      cuda = true;
      gc = true;
      gcDates = "weekly";
      optimize = true;
      optimiseDates = "weekly";
    };
    sddm = {
      enable = true;
      useStylix = false;
    };
  };

  system.stateVersion = "24.05"; # Don't touch
}
