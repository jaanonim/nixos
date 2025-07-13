{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.my.locale;
in {
  options.my.locale = {
    timeZone = mkOption {
      type = types.str;
      default = "Europe/Warsaw";
      description = "Time zone";
    };
    locale = mkOption {
      type = types.str;
      default = "pl_PL.UTF-8";
      description = "Locale from i18n (LC)";
    };
    keyMap = mkOption {
      type = types.str;
      default = "pl";
      description = "Console keyMap";
    };
  };

  config = {
    time.timeZone = cfg.timeZone;

    i18n = {
      defaultLocale = cfg.locale;
      extraLocaleSettings = {
        LC_ADDRESS = cfg.locale;
        LC_IDENTIFICATION = cfg.locale;
        LC_MEASUREMENT = cfg.locale;
        LC_MONETARY = cfg.locale;
        LC_NAME = cfg.locale;
        LC_NUMERIC = cfg.locale;
        LC_PAPER = cfg.locale;
        LC_TELEPHONE = cfg.locale;
        LC_TIME = cfg.locale;
      };
    };

    console.keyMap = cfg.keyMap;
  };
}
