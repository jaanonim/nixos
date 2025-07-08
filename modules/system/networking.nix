{
  lib,
  config,
  ...
}:
with lib; let
  my = config.my;
  cfg = config.my.networking;
in {
  options.my.networking = {
    networkmanager = mkEnableOption "Network manager to control networking settings";
    firewall = mkEnableOption "Firewall";
    dns = mkOption {
      type = types.listOf types.str;
      default = ["192.168.1.150" "1.1.1.1" "1.0.0.1"];
      example = ["1.1.1.1" "1.0.0.1"];
      description = "List of DNS servers to use";
    };
  };

  config =
    {
      networking = {
        enableIPv6 = true;
        firewall.enable = cfg.firewall;
        nameservers = cfg.dns;
      };
    }
    // mkIf my.boot.optimize {
      systemd.services.NetworkManager-wait-online.enable = false;
    }
    // mkIf cfg.networkmanager {
      networking.networkmanager.enable = true;
      users.extraGroups.networkmanager.members = [my.mainUser];
    };
}
