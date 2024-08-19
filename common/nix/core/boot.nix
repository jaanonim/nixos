_: {
  boot = {
    loader = {
      timeout = 3;
      grub = {
        enable = true;
        device = "/dev/sda";
        useOSProber = true;
      };
    };
    initrd.systemd.enable = true;
  };
}
