{pkgs, ...}: {
  imports = [./colors.nix];

  my = {
    mainUser = "jaanonim";
    homeDirectory = "/home/jaanonim";
    extraUserGroups = ["wheel"];
    setPassword = false;
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
        powerlevel10k = true;
        zshNixShell = true;
      };
    };
    apps = [
      "activitywatch"
      "basic"
      "dev"
      "discord"
      "gaming"
      "ghostty"
      "git"
      "gpu-screen-recorder"
      "media"
      "nix_dev"
      "obsidian"
      "plasma"
      "syncthing"
      "terminal"
      "tmux"
      "tools"
      "wakatime"
    ];
    audio.enable = true;
    bluetooth.enable = true;
    stylix.enable = true;
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
        plasmaManager = true;
      };
    };
    devices = {
      printer = true;
      tablet = true;
      touchpad = true;
    };
    disks = {
      "/mnt/dane" = "/dev/disk/by-uuid/ee53362c-cad2-4ac1-9060-02c868233572";
    };
    docker = {
      enable = true;
      nvidia = true;
    };
    flatpak = true;
    locale = {
      keyMap = "pl";
      locale = "pl_PL.UTF-8";
      timeZone = "Europe/Warsaw";
    };
    networking = {
      dns = [
        "192.168.1.150"
        "1.1.1.1"
        "1.0.0.1"
      ];
      firewall = true;
      networkmanager = true;
    };
    ssh = {
      enable = false;
      insertPrivKeys = true;
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
      useStylix = true;
    };
    timers.yt = {
      enable = true;
      filePath = "/home/jaanonim/Muzyka/go_to_sleep.mp4";
      player = "brave";
      playerPackage = pkgs.brave;
      time = "23:45:00";
    };
    udev.enable = true;
    vfio = {
      enable = true;
      gpuPciAddress = "0000:01:00.0";
      gpuPciId = "10de 25a2";
      vm = {
        cpu = "6";
        ram = "12G";
        defaultImage = "/mnt/dane/Virtual/windows10.qcow2";
      };
    };
    virtualbox.enable = true;
    vpn.tailscale.enable = true;
    crossCompileSystems = ["aarch64-linux"];
  };

  system.stateVersion = "24.05"; # Don't touch
}
