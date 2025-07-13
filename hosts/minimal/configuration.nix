_: {
  my = {
    mainUser = "jaanonim";
    mainUserPassword = "password";
    homeDirectory = "/home/jaanonim";
    extraUserGroups = ["wheel"];
    hostname = "minimal";
    homeManager = true;
    shell = {
      aliases = {
        homepi = "ssh 192.168.1.150";
        nas = "ssh 192.168.1.102";
        nd = "nix develop -c zsh";
        ns = "NIXPKGS_ALLOW_UNFREE=1 nix-shell -p $(nsearch)";
        ports = "lsof -i -P -n | grep LISTEN";
      };
      zsh = {
        enable = true;
        ohMyZsh = {
          enable = true;
        };
        zshNixShell = true;
      };
    };
    boot = {
      bootloaderTimeout = 0;
      grubConfigurationLimit = 16;
      optimize = true;
    };
    locale = {
      keyMap = "pl";
      locale = "pl_PL.UTF-8";
      timeZone = "Europe/Warsaw";
    };
    nix = {
      allowUnfree = true;
    };
  };

  system.stateVersion = "24.05"; # Don't touch
}
