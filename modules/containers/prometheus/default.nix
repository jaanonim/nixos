{
  config,
  lib,
  inputs,
  ...
}:
with lib; let
  inherit (config) my;
  cfg = my.containers.prometheus;
  nodeCfg = my.containers.nodeExporter;
  nodePort = 9002;
in {
  options.my.containers = {
    prometheus = {
      enable = mkEnableOption "prometheus";
      pingTargets = mkOption {
        type = types.listOf types.str;
        default = [];
        example = ["1.1.1.1" "8.8.8.8"];
        description = "List of addresses for ping exporter (disabled if empty)";
      };
      speedtest = mkEnableOption "speedtest exporter";
    };
    nodeExporter = {
      enable = mkEnableOption "node exporter";
    };
  };

  config = mkMerge [
    (mkIf cfg.enable {
      virtualisation.oci-containers.containers = mkIf cfg.speedtest {
        speedtest-exporter = {
          image = "ghcr.io/miguelndecarvalho/speedtest-exporter:v3.5.4@sha256:e0cb5f0a6cee1a0af000be2003ccfbe59de06ca7f277f9ef293e2e2e31a0432f";
          ports = ["9798:9798"];
        };
      };

      services = {
        prometheus = {
          enable = true;
          port = 9000;

          globalConfig.scrape_interval = "30s";

          exporters = {
            ping = mkIf (builtins.length cfg.pingTargets > 0) {
              enable = true;
              port = 9004;
              settings = {
                targets = cfg.pingTargets;
              };
            };
          };

          scrapeConfigs = let
            makeNodeExporter = host: ip: {
              job_name = "node_${host}";
              static_configs = [
                {
                  targets = [
                    "${ip}:${toString nodePort}"
                  ];
                }
              ];
            };
            haveNodeExporter = hostname: inputs.self.nixosConfigurations.${hostname}.config.my.containers.nodeExporter.enable;
            nodeExporters =
              mapAttrsToList (
                hostname: host: makeNodeExporter hostname host.ip
              )
              (filterAttrs (hostname: host: haveNodeExporter hostname) my.infrastructure.hosts);
          in
            nodeExporters
            ++ optional (builtins.length cfg.pingTargets > 0) {
              job_name = "ping";
              static_configs = [
                {
                  targets = [
                    "localhost:${toString config.services.prometheus.exporters.ping.port}"
                  ];
                }
              ];
            }
            ++ optional cfg.speedtest {
              job_name = "speedtest";
              scrape_interval = "1h";
              scrape_timeout = "1m";
              static_configs = [
                {
                  targets = [
                    "localhost:9798"
                  ];
                }
              ];
            };
        };

        nginx.virtualHosts."prometheus.${my.containers._hostDomain}" = mkMerge [
          {
            locations."/" = {
              proxyPass = "http://127.0.0.1:9000";
              proxyWebsockets = true;
              recommendedProxySettings = true;
            };
          }
          my.containers.nginx._extraConf
        ];

        grafana.provision.datasources.settings.datasources = [
          {
            name = "Prometheus";
            type = "prometheus";
            access = "proxy";
            url = "https://prometheus.${my.containers._hostDomain}";
          }
        ];
      };
    })
    (mkIf nodeCfg.enable {
      services.prometheus.exporters.node = {
        enable = true;
        port = nodePort;
        enabledCollectors = ["systemd"];
        openFirewall = !cfg.enable;
      };
    })
  ];
}
