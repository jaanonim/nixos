{pkgs, ...}: {
  services = {
    printing = {
      enable = true;
      drivers = [pkgs.brlaser];
    };
    libinput.enable = true;
  };

  hardware.opentabletdriver.enable = true;
}
