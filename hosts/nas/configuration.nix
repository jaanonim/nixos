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

    boot = {
      bootloaderTimeout = 0;
      optimize = true;
      bootloader = "systemd";
    };

    shell.zsh = {
      enable = true;
      ohMyZsh.enable = true;
      powerlevel10k = true;
      zshNixShell = true;
    };

    zfs = {
      enable = true;
      pools = ["main"];
    };

    networking = {
      networkmanager = false;
      wakeOnLan = true;
      interface = "enp2s0";
      dns = ["192.168.1.150" "1.1.1.1" "1.1.2.2"];
    };

    containers = {
      samba = {
        enable = true;
        settings = {
          "public" = {
            "path" = "/main/public";
            "browseable" = "yes";
            "guest ok" = "yes";
            "read only" = "yes";
            "write list" = "@users";
            "create mask" = "0644";
            "directory mask" = "0755";
            "force group" = "users";
          };

          "dane" = {
            "path" = "/main/dane";
            "browseable" = "yes";
            "guest ok" = "no";
            "read only" = "no";
            "valid users" = "@users";
            "create mask" = "0660";
            "directory mask" = "0770";
            "force group" = "users";
          };
        };
      };
      nodeExporter.enable = true;
      nginx.enable = true;
      immich = {
        enable = true;
        mediaLocation = "/main/dane/Immich";
      };
      cockpit.enable = true;
    };
  };

  system.stateVersion = "24.05"; # Don't touch
}
