_: {
  my = {
    mainUser = "jaanonim";
    setPassword = true;
    sops = true;
    homeManager = true;

    ssh = {
      enable = true;
      insertPrivKeys = true;
    };

    shell.zsh = {
      enable = true;
      ohMyZsh.enable = true;
      powerlevel10k = true;
      zshNixShell = true;
    };

    networking = {
      networkmanager = false;
      interface = "enu1u1";
      ip = "192.168.1.150";
    };
  };

  system.stateVersion = "24.05"; # Don't touch
}
