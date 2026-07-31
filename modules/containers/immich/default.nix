{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  inherit (config) my;
  cfg = my.containers.immich;
in {
  options.my.containers.immich = {
    enable = mkEnableOption "immich";
    mediaLocation = mkOption {
      type = types.str;
      default = "/var/lib/immich";
      description = "Location to store media files";
    };
  };

  config = mkIf cfg.enable {
    services = {
      postgresql.package = pkgs.postgresql_17;

      immich = {
        enable = true;
        port = 7000;
        host = "0.0.0.0";
        openFirewall = true;
        inherit (cfg) mediaLocation;
        accelerationDevices = null;
      };

      nginx.virtualHosts."immich.${my.containers._hostDomain}" = mkMerge [
        {
          locations."/" = {
            proxyPass = "http://127.0.0.1:7000";
            proxyWebsockets = true;
            recommendedProxySettings = true;
            extraConfig = ''
              client_max_body_size 50000M;
              proxy_read_timeout   600s;
              proxy_send_timeout   600s;
              send_timeout         600s;
            '';
          };
        }
        my.containers.nginx._extraConf
      ];
    };

    users.extraGroups.immich.members = [my.mainUser];
    users.users.immich.extraGroups = ["video" "render"];

    my.containers.homepage.hosts.${my.hostname}.services.immich = {
      description = "High performance self-hosted photo and video management solution.";
    };
  };
}
