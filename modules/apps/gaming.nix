{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  inherit (config) my;
  _envOverride = pkg:
    pkg.override {
      extraEnv = {
        __GLX_VENDOR_LIBRARY_NAME = "nvidia";
        __EGL_VENDOR_LIBRARY_FILENAMES = "/run/opengl-driver/share/glvnd/egl_vendor.d/10_nvidia.json";
      };
    };
  envOverride = pkg:
    if my.vfio.enable
    then _envOverride pkg
    else pkg;
in {
  config = mkIf (builtins.any (ele: (ele == (lib.removeSuffix ".nix" (baseNameOf __curPos.file)))) my.apps) {
    my._packages = with pkgs; [
      prismlauncher
      (envOverride heroic)
    ];

    programs = {
      steam = {
        enable = true;
        extest.enable = true;
        package = envOverride pkgs.steam;
      };
    };
  };
}
