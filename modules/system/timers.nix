{
  lib,
  config,
  ...
}:
with lib; let
  inherit (config) my;
  cfg = config.my.timers.yt;
in {
  options.my.timers.yt = {
    enable = mkEnableOption "yt timer";
    time = mkOption {
      type = types.str;
      example = "12:00:00";
      description = "Time to play video";
    };
    player = mkOption {
      type = types.str;
      example = "brave";
      description = "Target player name";
    };
    playerPackage = mkOption {
      type = types.package;
      example = lib.literalExpression "pkgs.brave";
      description = "Target player package";
    };
    filePath = mkOption {
      type = types.str;
      example = "/home/jaanonim/Muzyka/go_to_sleep.mp4";
      description = "File to be played";
    };
  };

  config = mkIf cfg.enable {
    systemd.timers."yt" = {
      wantedBy = ["timers.target"];
      timerConfig = {
        OnCalendar = "*-*-* ${cfg.time}";
        Persistent = true;
        Unit = "yt.service";
      };
    };

    systemd.services."yt" = {
      script = ''
        ${cfg.player} ${escapeShellArg cfg.filePath}
      '';
      serviceConfig = {
        Type = "oneshot";
        User = my.mainUser;
      };
      path = [
        cfg.playerPackage
      ];
    };
  };
}
