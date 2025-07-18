{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  inherit (config) my;
in {
  config = mkIf (builtins.any (ele: (ele == (lib.removeSuffix ".nix" (baseNameOf __curPos.file)))) my.apps) {
    my._packages = with pkgs; [
      gns3-gui
      inetutils
    ];

    services.gns3-server = {
      enable = true;
      dynamips.enable = true;
      ubridge.enable = true;
    };
  };
}
