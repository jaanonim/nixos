{
  pkgs,
  config,
  ...
}: {
  # TODO: Fix with nvidia
  packages = with pkgs; [
    gpu-screen-recorder-gtk
    (pkgs.runCommand "gpu-screen-recorder" {
        nativeBuildInputs = [pkgs.makeWrapper];
      } ''
        mkdir -p $out/bin
        makeWrapper ${pkgs.gpu-screen-recorder}/bin/gpu-screen-recorder $out/bin/gpu-screen-recorder \
          --prefix LD_LIBRARY_PATH : ${pkgs.libglvnd}/lib \
          --prefix LD_LIBRARY_PATH : ${config.boot.kernelPackages.nvidia_x11}/lib
      '')
  ];

  systemd.services.gpu-screen-recorder.enable = true;
}
