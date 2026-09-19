{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  inherit (config) my;
  cfg = my.containers.printer;
in {
  options.my.containers.printer = {
    enable = mkEnableOption "printer sharing service";
    allowFrom = mkOption {
      type = types.listOf types.str;
      default = ["all"];
      example = ["127.0.0.1" "192.168.1.*" "192.168.0.*"];
      description = "List of IP addresses or CIDR ranges allowed to access the printer service.";
    };
  };

  config = mkIf cfg.enable {
    services.printing = {
      enable = true;
      listenAddresses = ["*:631"];
      inherit (cfg) allowFrom;
      drivers = [pkgs.brlaser];
      browsing = true;
      defaultShared = true;
      openFirewall = true;
    };

    services.avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
      publish = {
        enable = true;
        userServices = true;
      };
    };
  };
}
