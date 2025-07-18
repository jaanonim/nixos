{
  pkgs,
  lib,
  inputs,
  config,
  ...
} @ args:
with lib; let
  inherit (config) my;
  cfg = config.my.sddm;
  base16Scheme = (inputs.stylix.inputs.base16.lib args).mkSchemeAttrs config.stylix.base16Scheme;
  wallpaper = config.stylix.image;
  cursor = config.stylix.cursor.name;
in {
  options.my.sddm = {
    enable = mkEnableOption "SDDM";
    useStylix = mkOption {
      type = types.bool;
      default = true;
      example = false;
      description = "Whether to use stylix colors, cursor and wallpaper";
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.useStylix -> my.stylix.enable;
        message = "to use stylix in sddm, stylix need to be enabled";
      }
    ];

    services.displayManager.sddm = {
      enable = true;
      enableHidpi = false;
      autoNumlock = true;
      wayland = mkIf (my.desktop.displayManager == "wayland") {enable = true;};

      # SDDM cursor
      settings = mkIf cfg.useStylix {
        Theme = {
          CursorTheme = cursor;
        };
      };
    };

    # SDDM wallpaper
    environment = mkIf cfg.useStylix {
      systemPackages = [
        (pkgs.writeTextDir "share/sddm/themes/breeze/theme.conf.user" ''
          [General]
          background=${wallpaper}
          type=image
        '')
      ];
    };

    # SDDM colors
    systemd.tmpfiles = mkIf cfg.useStylix {
      rules = [
        "L+ /var/lib/sddm/.config/kdeglobals - - - - ${lib.kdeColorScheme base16Scheme}/kdeglobals"
      ];
    };
  };
}
