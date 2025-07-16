{
  pkgs,
  lib,
  ...
}:
with lib; {
  my = {
    hostname = "homepi";
    mainUser = "nixos";
    mainUserPassword = "pass";
    homeManager = true;
    extraUserPackages = with pkgs; [libraspberrypi];

    ssh = {
      enable = true;
      insertPrivKeys = false;
    };
  };

  boot.kernelParams = [
    "console=ttyS1,115200n8"
  ];
  boot.loader.grub.enable = mkForce false;
  boot.loader.generic-extlinux-compatible.enable = true;

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
      options = ["noatime"];
    };
  };
  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 1024; # 1 GB
    }
  ];

  system.stateVersion = "24.05"; # Don't touch
}
