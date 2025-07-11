{
  pkgs,
  lib,
  inputs,
  config,
  ...
} @ args:
with lib; let
  my = config.my;
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

  config =
    mkIf cfg.enable {
      services.displayManager.sddm = {
        enable = true;
        enableHidpi = false;
        autoNumlock = true;
        wayland.enable = my.display.displayManager == "wayland";
      };
    }
    // mkIf (cfg.enable && cfg.useStylix) {
      # SDDM cursor
      services.displayManager.sddm = {
        settings = {
          Theme = {
            CursorTheme = cursor;
          };
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
        "L+ /var/lib/sddm/.config/kdeglobals - - - - ${lib.kdeColorScheme base16Scheme}/kdeglobals"
      ];
    };
}
