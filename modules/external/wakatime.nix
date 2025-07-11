# https://github.com/sagikazarmark/nix-config/blob/main/modules/home-manager/programs/wakatime.nix
{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.programs.wakatime;

  iniFormat = pkgs.formats.ini {};

  iniFile = iniFormat.generate ".wakatime.cfg" cfg.settings;
in {
  options.programs.wakatime = {
    enable = mkEnableOption "WakaTime command line interface";

    settings = mkOption {
      inherit (iniFormat) type;
      default = {};
      example = {
        settings = {
          debug = false;
        };
      };
      description = ''
        Configuration to use for Wakatime CLI. See
        <link xlink:href="https://github.com/wakatime/wakatime-cli/blob/develop/USAGE.md#ini-config-file"/>
        for available options.
      '';
    };
  };

  config = mkIf cfg.enable {
    home.file.".wakatime.cfg" = {
      source = iniFile;
    };
  };
}
