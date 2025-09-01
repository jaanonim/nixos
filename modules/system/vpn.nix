{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.my.vpn.tailscale;
  inherit (config) my;
in {
  options.my.vpn.tailscale = {
    enable = mkEnableOption "Tailscale vpn";
    withTailTray = mkOption {
      type = types.bool;
      default = false;
      description = "Add tail-tray GUI for tailscale";
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
      }
      // lib.optionalAttrs cfg.useAuthKey {
        authKeyFile = config.sops.secrets.tailscale-auth-key.path;
      }
      // lib.optionalAttrs (builtins.length cfg.advertiseRoutes > 0) {
        extraUpFlags = [
          ("--advertise-routes=" + (builtins.concatStringsSep "," cfg.advertiseRoutes))
        ];
      };

    environment = mkIf cfg.withTailTray {
      systemPackages = with pkgs; [tail-tray];
      etc."xdg/autostart/tail-tray.desktop".source = "${pkgs.tail-tray}/share/applications/tail-tray.desktop";
    };
  };
}
