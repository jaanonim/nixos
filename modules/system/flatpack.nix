{
  lib,
  config,
  ...
}:
with lib; let
  my = config.my;
in {
  options.my = {
    flatpak = mkEnableOption "flatpak";
  };
  services.flatpak.enable = my.flatpak;
}
