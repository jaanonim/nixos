{
  config,
  lib,
  ...
}:
with lib; let
  inherit (config) my;
  cfg = my.containers.chrony;
in {
  options.my.containers.chrony = {
    enable = mkEnableOption "NTP server with chrony";
    upstream = mkOption {
      type = types.listOf types.str;
      default = [
        "0.pl.pool.ntp.org"
        "1.pl.pool.ntp.org"
        "2.pl.pool.ntp.org"
        "3.pl.pool.ntp.org"
      ];
      example = [
        "ntp-example.com"
      ];
      description = "NTP servers form witch to get time";
    };
    allow = mkOption {
      type = types.str;
      default = "0/0";
      example = "192.168.0.0/24";
      description = "Allowed range of ips that can ask for time";
    };
    exporter = mkEnableOption "chrony exporter";
  };

  config = mkIf cfg.enable {
    services = {
      chrony = mkIf cfg.enable {
        enable = true;
        servers = cfg.upstream;
        extraConfig = "allow ${cfg.allow}";
      };

      prometheus = mkIf cfg.exporter {
        exporters.chrony.enable = true;
        scrapeConfigs = [
          {
            job_name = "chrony";
            static_configs = [{targets = ["localhost:${toString config.services.prometheus.exporters.chrony.port}"];}];
          }
        ];
      };
    };
  };
}
