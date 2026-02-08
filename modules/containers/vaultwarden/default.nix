/*
!DON'T USE
Missing backup solution
*/
{
  config,
  lib,
  ...
}:
with lib; let
  inherit (config) my;
  cfg = my.containers.vaultwarden;
  domain = "vaultwarden.${my.containers._hostDomain}";
in {
  options.my.containers.vaultwarden = {
    enable = mkEnableOption "vaultwarden";
  };

  config = mkIf cfg.enable {
    services.vaultwarden = {
      enable = true;
      backupDir = "/var/local/vaultwarden/backup";

      config = {
        DOMAIN = "https://${domain}";
        SIGNUPS_ALLOWED = true;

        ROCKET_ADDRESS = "127.0.0.1";
        ROCKET_PORT = 8222;
        ROCKET_LOG = "critical";
      };
    };
    services.nginx.virtualHosts.${domain} = mkMerge [
      {
        locations."/" = {
          proxyPass = "http://${toString config.services.vaultwarden.config.ROCKET_ADDRESS}:${toString config.services.vaultwarden.config.ROCKET_PORT}";
          proxyWebsockets = true;
          recommendedProxySettings = true;
        };
      }
      my.containers.nginx._extraConf
    ];

    my.containers.homepage.hosts.${my.hostname}.services.vaultwarden = {
      description = "Unofficial Bitwarden compatible server written in Rust, formerly known as bitwarden_rs.";
    };
  };
}
