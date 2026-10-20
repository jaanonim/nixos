{
  pkgs,
  inputs,
  lib,
  ...
}: {
  stylix = {
    image = lib.wrapImage "wallpaper.jpg";

    base16Scheme = "${inputs.tt-schemes}/base16/material-darker.yaml";

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
        package = pkgs.noto-fonts-color-emoji;
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

    opacity = {
      popups = 0.7;
      desktop = 0.7;
      terminal = 0.9;
    };

    cursor = {
      package = pkgs.phinger-cursors;
      name = "phinger-cursors-dark";
      size = 24;
    };
  };
}
