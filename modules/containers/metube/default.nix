{
  config,
  lib,
  ...
}:
with lib; let
  inherit (config) my;
  cfg = my.containers.metube;
in {
  options.my.containers.metube = {
    enable = mkEnableOption "metube";
    downloadDir = mkOption {
      type = types.path;
      default = "/var/lib/metube/downloads";
      description = "Host directory mounted into the container at /downloads.";
    };
  };

  config = mkIf cfg.enable {
    virtualisation.oci-containers.containers.ism = {
      image = "ghcr.io/alexta69/metube:2026.11.10@sha256:6b28bbbf8500359515c7a241843a777d050de4e93a3560cb36bae8b9cfe36385";
      hostname = "metube";

      ports = ["8081:8081"];

      volumes = [
        "${cfg.downloadDir}:/downloads"
      ];

      environment = {
        PUID = "1000";
        PGID = "1000";
      };
    };

    services.nginx.virtualHosts."metube.${my.containers._hostDomain}" = mkMerge [
      {
        locations."/" = {
          proxyPass = "http://127.0.0.1:8081";
          proxyWebsockets = true;
          recommendedProxySettings = true;
        };
      }
      my.containers.nginx._extraConf
    ];

    my.containers.homepage.hosts.${my.hostname}.services.metube = {
      description = "Self-hosted video downloader for YouTube and other sites (web UI for yt-dlp).";
      icon = "sh-metube";
    };
  };
}
