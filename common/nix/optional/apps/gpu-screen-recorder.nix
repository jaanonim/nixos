{pkgs, ...}: {
  packages = with pkgs; [
    gpu-screen-recorder-gtk
    gpu-screen-recorder
  ];

  systemd.services.gpu-screen-recorder.enable = true;
}
