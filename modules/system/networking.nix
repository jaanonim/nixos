{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  inherit (config) my;
  cfg = config.my.networking;
in {
  options.my.networking = {
    networkmanager = mkEnableOption "Network manager to control networking settings (if not enabled dhcp and static configuration will be used)";
    firewall = mkEnableOption "Firewall";
    dns = mkOption {
      type = types.listOf types.str;
      default = ["1.1.1.1" "1.0.0.1"];
      example = ["8.8.8.8"];
      description = "List of DNS servers to use";
    };
    mask = mkOption {
      type = types.int;
      default = 24;
      example = 16;
      description = "Mask for specified ip";
    };
    interface = mkOption {
      type = types.nullOr types.str;
      example = "ens1";
      description = "Interface that will have static ip";
    };
    ip = mkOption {
      type = types.str;
      example = "192.168.1.5";
      description = "Static IPv4 for specified interface";
    };
    gateway = mkOption {
      type = types.str;
      default = "192.168.1.1";
      example = "192.168.0.1";
      description = "Default gateway for specified interface";
    };
  };

  config = {
    networking = {
      enableIPv6 = true;
      firewall.enable = cfg.firewall;
      nameservers = cfg.dns;
      hostName = my.hostname;
      useDHCP = !cfg.networkmanager;

      interfaces = mkIf (!cfg.networkmanager) {
        ${cfg.interface} = {
          ipv4.addresses = [
            {
              address = cfg.ip;
              prefixLength = cfg.mask;
            }
          ];
        };
      };

      defaultGateway = mkIf (!cfg.networkmanager) {
        address = cfg.gateway;
        inherit (cfg) interface;
      };
    };

    systemd.services.NetworkManager-wait-online.enable = my.boot.optimize;

    networking.networkmanager = mkIf cfg.networkmanager {
      enable = true;
      dns = "none";
      plugins = with pkgs; [
        networkmanager-openvpn
      ];
    };
    users.extraGroups.networkmanager = mkIf cfg.networkmanager {members = [my.mainUser];};
  };
}
