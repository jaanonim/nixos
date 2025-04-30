_: {
  boot = {
    loader = {
      timeout = 1;
      systemd-boot.enable = false;
      efi.canTouchEfiVariables = true;
      grub = {
        efiSupport = true;
        device = "nodev";
        configurationLimit = 16;
      };
    };
    # kernelParams = ["quiet"];
  };
  services.journald.extraConfig = "SystemMaxUse=512M";
  systemd.extraConfig = "DefaultTimeoutStopSec=16s";
}
