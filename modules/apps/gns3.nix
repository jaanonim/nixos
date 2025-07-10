{pkgs, ...}: {
  my._packages = with pkgs; [
    gns3-gui
    inetutils
  ];

  services.gns3-server = {
    enable = true;
    dynamips.enable = true;
    ubridge.enable = true;
  };
}
