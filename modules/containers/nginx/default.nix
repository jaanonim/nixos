{
  inputs,
  config,
  lib,
  ...
}:
with lib; let
  secrets-path = builtins.toString inputs.jaanonim-secrets;
  inherit (config) my;
  cfg = my.containers.nginx;
in {
  options.my.containers.nginx = {
    _extraConf = mkOption {
      type = types.attrsOf types.unspecified;
      default = {};
      internal = true;
      description = "Extra config passed to each virtual host";
    };
    enable = mkEnableOption "Nginx proxy container";
    useHttps = mkOption {
      type = types.bool;
      default = true;
      example = false;
      description = " Whether to force https";
    };
    exporter = mkEnableOption "nginx exporter";
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.useHttps -> my.sops;
        message = "Sops need to be enabled to insert use https";
      }
    ];

    services.nginx = {
      enable = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
      statusPage = cfg.exporter;
    };

    sops.secrets."ssl-key" = mkIf cfg.useHttps {
      sopsFile = "${secrets-path}/ssl/${my.containers._hostDomain}/key.pem";
      format = "binary";
      owner = "nginx";
      group = "nginx";
      mode = "0400";
    };

    my.containers.nginx._extraConf =
      if cfg.useHttps
      then {
        forceSSL = true;
        sslCertificate = "${secrets-path}/ssl/${my.containers._hostDomain}/cert.pem";
        sslCertificateKey = config.sops.secrets."ssl-key".path;
      }
      else {};

    services.prometheus = mkIf cfg.exporter {
      exporters.nginx = {
        enable = true;
        port = 9003;
      };
      scrapeConfigs = [
        {
          job_name = "nginx";
          static_configs = [
            {
              targets = [
                "localhost:${toString config.services.prometheus.exporters.nginx.port}"
              ];
            }
          ];
        }
      ];
    };
  };
}
