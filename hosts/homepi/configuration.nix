{
  config,
  lib,
  ...
}: {
  my = {
    mainUser = "jaanonim";
    setPassword = true;
    sops = true;
    homeManager = true;

    ssh = {
      enable = true;
      insertPrivKeys = true;
    };

    boot = {
      bootloader = "none";
      optimize = false;
    };

    shell.zsh = {
      enable = true;
      ohMyZsh.enable = true;
      powerlevel10k = true;
      zshNixShell = true;
    };

    networking = {
      networkmanager = false;
      interface = "enu1u1";
      dns = ["127.0.0.1" "1.1.1.1" "1.1.2.2"];
    };

    containers = {
      grafana.enable = true;
      prometheus = {
        enable = true;
        pingTargets = ["1.1.1.1" "8.8.8.8"] ++ (lib.mapAttrsToList (_: v: v.ip) config.my.infrastructure.hosts);
        speedtest = true;
      };
      nginx = {
        enable = true;
        exporter = true;
      };
      blocky = {
        enable = true;
        exporter = true;
        api = true;
      };
      ism = {
        enable = true;
        exporter = true;
      };
      chrony = {
        enable = true;
        allow = "192.168.1.0/24";
        upstream = [
          "0.pl.pool.ntp.org"
          "1.pl.pool.ntp.org"
          "2.pl.pool.ntp.org"
          "3.pl.pool.ntp.org"
          "194.146.251.100" # tempus1.gum.gov.pl
          "194.146.251.101" # tempus2.gum.gov.pl
        ];
        exporter = true;
        syncOnStart = true;
      };
      homepage = {
        enable = true;
        hosts = {
          homepi = {
            description = "Always on raspberry pi server for critical services.";
            icon = "sh-homepage";
          };
          nas = {
            description = "Main nas sever for heavy tasks.";
            icon = "sh-truenas-scale";
            services = {
              immich = {
                description = "High performance self-hosted photo and video management solution.";
              };
              metube = {
                description = "Self-hosted YouTube downloader.";
              };
              kasm = {
                description = "A platform for streaming desktops, apps, and browsers securely.";
                icon = "sh-kasm-workspaces";
              };
            };
          };
        };
      };
    };

    vpn.tailscale = {
      enable = true;
      useAuthKey = true;
      advertiseRoutes = ["192.168.1.0/24"];
    };
  };

  system.stateVersion = "24.05"; # Don't touch
}
