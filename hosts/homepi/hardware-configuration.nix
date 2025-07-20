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
      size = 1024; # 1 GB
    }
  ];

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
