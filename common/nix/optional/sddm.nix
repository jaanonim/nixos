{
  pkgs,
  lib,
  configLib,
  inputs,
  config,
  ...
}: let
  base16SchemeFile = config.stylix.base16Scheme;
  wallpaper = config.stylix.image;
  cursor = config.stylix.cursor.name;
in {
  # SDDM cursors
  services.displayManager.sddm.settings = {
    Theme = {
      CursorTheme = cursor;
    };
  };
  # SDDM wallpaper
  environment.systemPackages = [
    (pkgs.writeTextDir "share/sddm/themes/breeze/theme.conf.user" ''
      [General]
      background=${wallpaper}
      type=image
    '')
  ];
  # SDDM colors
  systemd.tmpfiles.rules = [
    "L+ /var/lib/sddm/.config/kdeglobals - - - - ${configLib.get_util "kde-color-sheme" {
      inherit
        pkgs
        lib
        configLib
        inputs
        base16SchemeFile
        ;
    }}/kdeglobals"
  ];
}
