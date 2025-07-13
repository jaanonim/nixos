{modulesPath, ...}: {
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
  ];

  my = {
    mainUser = "jaanonim";
    mainUserPassword = "password";
    homeDirectory = "/home/jaanonim";
    extraUserGroups = ["wheel"];
    hostname = "iso";
    homeManager = true;
    shell = {
      zsh = {
        enable = true;
        ohMyZsh = {
          enable = true;
        };
        zshNixShell = true;
      };
    };
    audio.enable = true;
    bluetooth.enable = true;
    devices = {
      touchpad = true;
    };
    locale = {
      keyMap = "pl";
      locale = "pl_PL.UTF-8";
      timeZone = "Europe/Warsaw";
    };
    networking = {
      firewall = false;
      networkmanager = true;
      ssh = true;
    };
    nix = {
      allowUnfree = true;
    };
    boot = {
      bootloaderTimeout = 10;
    };
  };

  system.stateVersion = "24.05"; # Don't touch
}
