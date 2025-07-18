{
  lib,
  config,
  ...
}:
with lib; let
  inherit (config) my;
in {
  options.my = {
    flatpak = mkEnableOption "flatpak";
  };

  config = {
    services.flatpak.enable = my.flatpak;
  };
}
