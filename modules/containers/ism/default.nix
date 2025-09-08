{
  config,
  lib,
  ...
}:
with lib; let
  inherit (config) my;
  cfg = my.containers.ism;
in {
  options.my.containers.ism = {
    enable = mkEnableOption "ism";
    exporter = mkEnableOption "ism exporter";
    ntp = {
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
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = my.sops;
        message = "to use ism, sops need to be enabled";
      }
    ];

    sops = {
      secrets = {
        "containers/admin-password" = {};
        "containers/ism/jwt-key" = {};
        "containers/ism/nas-mac" = {};
      };

      templates."ism-env" = {
        content = ''
          USER_NAME=admin
          USER_PASSWORD=${config.sops.placeholder."containers/admin-password"}
          SECRET_KEY=${config.sops.placeholder."containers/ism/jwt-key"}
          NAS_MAC=${config.sops.placeholder."containers/ism/nas-mac"}
        '';
      };

      templates."ism-exporter-env" = mkIf cfg.exporter {
        content = ''
          USERNAME=admin
          PASSWORD=${config.sops.placeholder."containers/admin-password"}
          URL=http://127.0.0.1:5000
          PULL_INTERVAL=30
          NAME=ISMP
        '';
      };
    };

    virtualisation.oci-containers.containers = mkMerge [
      {
        ism = {
          image = "ghcr.io/jaanonim/ism:latest@sha256:9780b2aa5f8c8a28f4247ff2591ea1056f5fc99be9c7c3c7e41f9381c6465152";
          hostname = "ism";
          networks = ["host"];
          environmentFiles = [
            config.sops.templates."ism-env".path
          ];
        };
      }
      (mkIf cfg.exporter {
        ism-exporter = {
          image = "ghcr.io/jaanonim/ism-exporter:latest@sha256:b77fc4efd74c7fe75e39d6c75bcad9116d9833249571d9627b597753cf173d62";
          networks = ["host"];
          environmentFiles = [
            config.sops.templates."ism-exporter-env".path
          ];
        };
      })
    ];

    services = {
      chrony = mkIf cfg.ntp.enable {
        enable = true;
        servers = cfg.ntp.upstream;
      };

      nginx.virtualHosts."ism.${my.containers._hostDomain}" = mkMerge [
        {
          locations."/" = {
            proxyPass = "http://127.0.0.1:5000";
            proxyWebsockets = true;
            recommendedProxySettings = true;
          };
        }
        my.containers.nginx._extraConf
      ];

      prometheus = mkIf cfg.exporter {
        scrapeConfigs = [
          {
            job_name = "ism";
            static_configs = [{targets = ["127.0.0.1:5950"];}];
          }
        ];
      };
    };

    my.containers.homepage.hosts.${my.hostname}.services.ism = {
      description = "My smart home app.";
      icon = "sh-esphome";
    };
  };
}
