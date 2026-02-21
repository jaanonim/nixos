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
  servicesYamlStr = ''
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
    sops = mkIf my.sops {
      secrets = {
        "containers/homepage/aqicn-token" = {};
      };

      templates."homepage-widgets" = {
        content =
          builtins.replaceStrings
          ["{{HOMEPAGE_VAR_AQICN_TOKEN}}"]
          [config.sops.placeholder."containers/homepage/aqicn-token"]
          servicesYamlStr;
      };
    };

    virtualisation.oci-containers.containers.homepage = {
      image = "ghcr.io/gethomepage/homepage:v1.10.1@sha256:4815be05c8abf3503272b7ff1ac40c5f7364602a1ed807b0fc5a4cf69df0b15b";
      ports = ["3000:3000"];
      pull = "always";
      volumes = [
        "${config.sops.templates."homepage-widgets".path}:/app/config/services.yaml:ro"
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
