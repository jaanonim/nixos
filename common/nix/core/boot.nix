_: {
  boot.loader = {
    timeout = 3;
    systemd-boot.enable = false;
    efi.canTouchEfiVariables = true;
    grub = {
      efiSupport = true;
      device = "nodev";
      configurationLimit = 16;
    };
  };
}
