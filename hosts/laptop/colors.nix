{
  pkgs,
  inputs,
  lib,
  configLib,
  ...
}: let
  wallpaper = pkgs.fetchurl {
    url = "https://images.unsplash.com/photo-1554176259-aa961fc32671?ixlib=rb-4.0.3&q=85&fm=jpg&crop=entropy&cs=srgb&dl=tyler-lastovich-ddLiNMqWAOM-unsplash.jpg";
    hash = "sha256-+pjhBCVwjuzx/r11nqZJI79FPhuPGqrzD1Hd90nEQys=";
    name = "wallpaper.jpg";
  };
  base16SchemeFile = "${pkgs.base16-schemes}/share/themes/material-darker.yaml";
in {
  imports = [inputs.stylix.nixosModules.stylix];

  # SDDM cursors
  services.displayManager.sddm.settings = {
    Theme = {
      CursorTheme = "capitaine-cursors";
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

  stylix = {
    enable = true;
    autoEnable = true;

    image = wallpaper;

    base16Scheme = base16SchemeFile;

    polarity = "dark";

    fonts = {
      serif = {
        package = pkgs.noto-fonts;
        name = "Noto Sans";
      };

      sansSerif = {
        package = pkgs.noto-fonts;
        name = "Noto Sans";
      };

      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };

      monospace = {
        package = pkgs.nerdfonts.override {fonts = ["Meslo"];};
        name = "MesloLGS Nerd Font Mono";
      };

      sizes = {
        applications = 10;
        terminal = 10;
      };
    };

    opacity.popups = 0.5;

    cursor = {
      package = pkgs.capitaine-cursors;
      name = "capitaine-cursors";
      size = 32;
    };
  };
}
