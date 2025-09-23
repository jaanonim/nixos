{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  inherit (config) my;
  cfg = my.containers.homepage;
  servicesList =
    mapAttrsToList (hostname: host: {
      ${toSentenceCase hostname} =
        (
          optional host.display
          {
            ${toSentenceCase hostname} =
              {
                href = "https://${hostname}.${my.infrastructure.domain}";
              }
              // lib.optionalAttrs host.ping {
                ping = "${hostname}.${my.infrastructure.domain}";
              }
              // lib.optionalAttrs (host.icon != null) {
                inherit (host) icon;
              }
              // lib.optionalAttrs (host.description != null) {
                inherit (host) description;
              };
          }
        )
        ++ (mapAttrsToList (serviceName: service: {
          ${toSentenceCase serviceName} =
            {
              href = "https://${serviceName}.${hostname}.${my.infrastructure.domain}";
              icon =
                if service.icon == null
                then "sh-${serviceName}"
                else service.icon;
            }
            // lib.optionalAttrs (service.description != null) {
              inherit (service) description;
            };
        }))
        host.services;
    })
    cfg.hosts;
  servicesYaml = pkgs.writeText "services.yaml" ''
    ${builtins.readFile ./services.yaml}
    ${builtins.readFile ((pkgs.formats.yaml {}).generate "services.yaml" servicesList)}
  '';
in {
  options.my.containers.homepage = let
    hostType = types.submodule {
      options = {
        description = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = "Host role description";
        };
        icon = mkOption {
          type = types.nullOr types.str;
          default = null;
          example = "sh-grafana";
          description = "Host icon";
        };
        display = mkOption {
          type = types.bool;
          default = true;
          example = false;
          description = "Whether to display host link with other widgets.";
        };
        ping = mkOption {
          type = types.bool;
          default = true;
          example = false;
          description = "Whether to display ping to host.";
        };
        services = mkOption {
          type = types.attrsOf serviceType;
          default = {};
          description = "Services on that host where key is service name";
        };
      };
    };
    serviceType = types.submodule {
      options = {
        icon = mkOption {
          type = types.nullOr types.str;
          default = null;
          example = "sh-grafana";
          description = "Service icon";
        };
        description = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = "Service description";
        };
      };
    };
  in {
    enable = mkEnableOption "homepage";
    hosts = mkOption {
      type = types.attrsOf hostType;
      description = "List of hosts for homepage where key is hostname";
      default = {};
    };
  };

  config = mkIf cfg.enable {
    virtualisation.oci-containers.containers.homepage = {
      image = "ghcr.io/gethomepage/homepage:v1.5@sha256:b82bba1c67e06ceb3d2b6d874e7bd1a6fb50e9cb8532651aa2fca5b25e5269cd";
      ports = ["3000:3000"];
      pull = "always";
      volumes = [
        "${servicesYaml}:/app/config/services.yaml:ro"
        "${./bookmarks.yaml}:/app/config/bookmarks.yaml:ro"
        "${./settings.yaml}:/app/config/settings.yaml:ro"
        "${./widgets.yaml}:/app/config/widgets.yaml:ro"
        "${./custom.css}:/app/config/custom.css:ro"
      ];
      extraOptions = [
        "--mount"
        "type=tmpfs,destination=/app/config"
      ];
      environment = {HOMEPAGE_ALLOWED_HOSTS = "${my.containers._hostDomain}";};
      capabilities = {NET_RAW = true;};
    };

    services.nginx.virtualHosts.${my.containers._hostDomain} = mkMerge [
      {
        locations."/" = {
          proxyPass = "http://127.0.0.1:3000";
          proxyWebsockets = true;
          recommendedProxySettings = true;
        };
      }
      my.containers.nginx._extraConf
    ];
  };
}
