{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.my.vpn.tailscale;
in {
  options.my.vpn.tailscale = {
    enable = mkEnableOption "Tailscale vpn";
    withTailTray = mkOption {
      type = types.bool;
      default = false;
      description = "Add tail-tray GUI for tailscale";
    };
  };

  config = mkIf cfg.enable {
    services.tailscale = {
      enable = true;
      extraSetFlags = ["--accept-routes=true" "--operator=jaanonim"];
    };

    environment = mkIf cfg.withTailTray {
      systemPackages = with pkgs; [tail-tray];
      etc."xdg/autostart/tail-tray.desktop".source = "${pkgs.tail-tray}/share/applications/tail-tray.desktop";
    };
  };
}
