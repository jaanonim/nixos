{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  inherit (config) my;
  cfg = my.containers.grafana;
in {
  options.my.containers.grafana = {
    enable = mkEnableOption "grafana";
  };

  config = mkIf cfg.enable {
    services.grafana = {
      enable = true;
      settings = {
        server = {
          http_addr = "127.0.0.1";
          http_port = 6000;
          domain = "grafana.${my.containers._hostDomain}";
        };
        panels = {
          disable_sanitize_html = true;
        };
      };
      declarativePlugins = with pkgs.grafanaPlugins; [grafana-piechart-panel];
    };

    services.nginx.virtualHosts.${config.services.grafana.settings.server.domain} = mkMerge [
      {
        locations."/" = {
          proxyPass = "http://${toString config.services.grafana.settings.server.http_addr}:${toString config.services.grafana.settings.server.http_port}";
          proxyWebsockets = true;
          recommendedProxySettings = true;
        };
      }
      my.containers.nginx._extraConf
    ];

    my.containers.homepage.hosts.${my.hostname}.services.grafana = {
      description = "The open and composable observability and data visualization platform.";
    };
  };
}
