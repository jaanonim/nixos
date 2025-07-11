_: {
  imports = [./colors.nix];

  my = {
    mainUser = "jaanonim";
    hostname = "Laptop";
    setPassword = true;
    sops = true;
    homeManager = true;
    networking = {
      ssh = true;
    };
    shell = {
      zsh.enable = true;
    };
    apps = [
      "terminal"
    ];
  };

  system.stateVersion = "24.05"; # Don't touch
}
