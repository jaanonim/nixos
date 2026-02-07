{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.my.vpn.tailscale;
  inherit (config) my;
in {
  options.my.vpn.tailscale = {
    enable = mkEnableOption "Tailscale vpn";
    systray = mkOption {
      type = types.bool;
      default = false;
      description = "Enable systray for tailscale";
    };
    useAuthKey = mkEnableOption "auth key form sops";
    advertiseRoutes = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      description = "List of CIDRs to be advertised";
      default = [];
      example = ["192.168.0.0/24"];
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.useAuthKey -> my.sops;
        message = "to use auth key, sops need to be enabled";
      }
    ];

    sops.secrets = mkIf cfg.useAuthKey {tailscale-auth-key = {};};

    services.tailscale =
      {
        enable = true;
        extraSetFlags = ["--accept-routes=true" "--operator=${my.mainUser}"];
        extraDaemonFlags = ["--no-logs-no-support"];
      }
      // lib.optionalAttrs cfg.useAuthKey {
        authKeyFile = config.sops.secrets.tailscale-auth-key.path;
      }
      // lib.optionalAttrs (builtins.length cfg.advertiseRoutes > 0) {
        extraUpFlags = [
          ("--advertise-routes=" + (builtins.concatStringsSep "," cfg.advertiseRoutes))
        ];
      };

    home-manager.users.${my.mainUser} = mkIf (cfg.systray && my.homeManager) {
      services.tailscale-systray.enable = true;
    };
  };
}
