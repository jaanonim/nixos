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

  # stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/tokyo-night-dark.yaml";

  # stylix.image = pkgs.fetchurl {
  #   url = "https://images.unsplash.com/photo-1467703834117-04386e3dadd8?ixlib=rb-4.0.3&q=85&fm=jpg&crop=entropy&cs=srgb&dl=anders-jilden-5sxQH0ugTaA-unsplash.jpg";
  #   hash = "sha256-kXWxrugHOlP1MKrGxYjxfiqhXEjoh/iFSvQ/S2q2OIg=";
  # };

  services.displayManager.sddm.settings = {
    Theme = {
      CursorTheme = "capitaine-cursors";
    };
  };

  environment.systemPackages = [
    (pkgs.writeTextDir "share/sddm/themes/breeze/theme.conf.user" ''
      [General]
      background=${wallpaper}
      type=image
    '')
  ];

  stylix = {
    enable = true;
    autoEnable = true;

    image = wallpaper;

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
