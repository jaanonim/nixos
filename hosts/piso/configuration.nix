_: {
  my = {
    mainUser = "jaanonim";
    mainUserPassword = "pass";
    setPassword = false;
    sops = false; # decryption keys for sops will not be available on iso image
    homeManager = true;

    ssh = {
      enable = true;
      insertPrivKeys = false;
    };

    shell.zsh = {
      enable = true;
      ohMyZsh.enable = true;
      powerlevel10k = true;
      zshNixShell = true;
    };

    networking.networkmanager = true;
  };

  system.stateVersion = "24.05"; # Don't touch
}
