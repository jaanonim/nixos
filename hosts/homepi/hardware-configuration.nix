{
  pkgs,
  lib,
  ...
}: {
  environment.systemPackages = with pkgs; [libraspberrypi];

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
      size = 4096; # 4 GB
    }
  ];
  zramSwap = {
    enable = true;
    memoryPercent = 50; # 1/2 of RAM becomes compressed
  };

  nix.settings = {
    max-jobs = 2;
    cores = 1;
  };

  hardware.deviceTree = {
    enable = true;
    filter = "bcm2837-rpi-3-b.dtb";
    overlays = [
      {
        name = "gpio-fan";
        dtsFile = lib.root /config/gpio-fan.dts;
      }
    ];
  };
}
