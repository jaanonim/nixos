{pkgs, ...}: {
  services.printing = {
    enable = true;
    drivers = [pkgs.brlaser];
  };

  hardware.opentabletdriver.enable = true;
}
