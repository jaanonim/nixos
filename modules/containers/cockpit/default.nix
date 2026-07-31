{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  inherit (config) my;
  cfg = my.containers.cockpit;

  fixedCockpit = pkgs.cockpit.overrideAttrs (old: {
    passthru =
      old.passthru
      // {
        python3Packages = old.passthru.python3Packages.overrideScope (pyfinal: pyprev: {
          py-libzfs = pkgs.python312Packages.py-libzfs.override {
            cython_0 = pkgs.python312Packages.cython_0.overrideAttrs (old: {
              dontCheckPythonMetadata = true;
            });
          };
        });
      };
  });
in {
  options.my.containers.cockpit = {
    enable = mkEnableOption "cockpit";
  };

  config = mkIf cfg.enable {
    services = {
      cockpit = {
        enable = true;
        port = 9090;
        openFirewall = true;
        plugins = optional my.zfs.enable (pkgs.cockpit-zfs.override {cockpit = fixedCockpit;});
        settings = {
          WebService = {
            AllowUnencrypted = true;
          };
        };
        allowed-origins = [
          "https://${my.containers._hostDomain}"
        ];
      };

      nginx.virtualHosts.${my.containers._hostDomain} = mkMerge [
        {
          locations."/" = {
            proxyPass = "http://127.0.0.1:9090";
            proxyWebsockets = true;
            recommendedProxySettings = true;
          };
        }
        my.containers.nginx._extraConf
      ];
    };

    my.containers.homepage.hosts.${my.hostname}.services.cockpit = {
      description = "The easy-to-use, integrated, glanceable, and open web-based interface for your servers.";
    };
  };
}
