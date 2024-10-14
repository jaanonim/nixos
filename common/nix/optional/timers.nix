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
      brave /home/jaanonim/Muzyka/go_to_sleep.mp4
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
