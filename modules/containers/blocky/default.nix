{
  config,
  lib,
  ...
}:
with lib; let
  inherit (config) my;
  cfg = my.containers.blocky;
in {
  options.my.containers.blocky = {
    enable = mkEnableOption "blocky dns";
    exporter = mkEnableOption "prometheus exporter";
    api = mkEnableOption "expose blocky api";
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.exporter -> cfg.api;
        message = "to use blocky exporter, blocky api need to be exposed";
      }
    ];
    services = {
      blocky = {
        enable = true;

        settings = {
          ports = mkIf cfg.api {
            http = 4000;
          };

          upstreams.groups.default = [
            "https://one.one.one.one/dns-query"
          ];

          bootstrapDns = {
            upstream = "https://one.one.one.one/dns-query";
            ips = ["1.1.1.1" "1.0.0.1"];
          };

          customDNS = {
            customTTL = "1h";
            mapping =
              mapAttrs' (hostname: value: {
                name = "${hostname}.${my.infrastructure.domain}";
                value = value.ip;
              })
              my.infrastructure.hosts;
          };

          blocking = {
            denylists = {
              ads = ["https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"];
              adult = ["https://blocklistproject.github.io/Lists/porn.txt"];
            };

            clientGroupsBlock = {
              default = ["ads" "adult"];
            };
          };

          prometheus.enable = cfg.exporter;
        };
      };

      prometheus = mkIf cfg.exporter {
        scrapeConfigs = [
          {
            job_name = "blocky";
            static_configs = [
              {
                targets = [
                  "127.0.0.1:${toString config.services.blocky.settings.ports.http}"
                ];
              }
            ];
          }
        ];
      };

      nginx.virtualHosts = mkIf cfg.api {
        "blocky.${my.containers._hostDomain}" = mkMerge [
          {
            locations."/" = {
              proxyPass = "http://127.0.0.1:${toString config.services.blocky.settings.ports.http}";
              recommendedProxySettings = true;
            };
          }
          my.containers.nginx._extraConf
        ];
      };
    };
  };
}
