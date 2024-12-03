{
  pkgs,
  inputs,
  ...
}: let
  wallpaper = pkgs.fetchurl {
    url = "https://images.unsplash.com/photo-1554176259-aa961fc32671?ixlib=rb-4.0.3&q=85&fm=jpg&crop=entropy&cs=srgb&dl=tyler-lastovich-ddLiNMqWAOM-unsplash.jpg";
    hash = "sha256-+pjhBCVwjuzx/r11nqZJI79FPhuPGqrzD1Hd90nEQys=";
    name = "wallpaper.jpg";
  };
in {
  imports = [inputs.stylix.nixosModules.stylix];

  stylix = {
    enable = true;
    autoEnable = true;

    image = wallpaper;

    base16Scheme = "${pkgs.base16-schemes}/share/themes/material-darker.yaml";

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
        package = pkgs.nerd-fonts.meslo-lg;
        name = "MesloLGS Nerd Font Mono";
      };

      sizes = {
        applications = 10;
        terminal = 10;
      };
    };

    opacity.popups = 0.7;

    cursor = {
      package = pkgs.capitaine-cursors;
      name = "capitaine-cursors";
      size = 32;
    };
  };
}
