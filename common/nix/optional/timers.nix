{pkgs, ...}: {
  systemd.timers."yt" = {
    wantedBy = ["timers.target"];
    timerConfig = {
      OnCalendar = "*-*-* 23:45:00";
      Persistent = true;
      Unit = "yt.service";
    };
  };

  systemd.services."yt" = {
    script = ''
      brave https://youtu.be/E5DFG2xwT00
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "jaanonim";
    };
    path = [
      pkgs.brave
    ];
  };
}
