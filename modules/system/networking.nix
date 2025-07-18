{
  lib,
  config,
  ...
}:
with lib; let
  inherit (config) my;
  cfg = config.my.networking;
in {
  options.my.networking = {
    networkmanager = mkEnableOption "Network manager to control networking settings";
    firewall = mkEnableOption "Firewall";
    dns = mkOption {
      type = types.listOf types.str;
      default = ["1.1.1.1" "1.0.0.1"];
      description = "List of DNS servers to use";
    };
  };

  config = {
    networking = {
      enableIPv6 = true;
      firewall.enable = cfg.firewall;
      nameservers = cfg.dns;
      hostName = my.hostname;
    };

    systemd.services.NetworkManager-wait-online.enable = my.boot.optimize;

    networking.networkmanager.enable = cfg.networkmanager;
    users.extraGroups = mkIf cfg.networkmanager {networkmanager.members = [my.mainUser];};
  };
}
