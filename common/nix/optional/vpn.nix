{pkgs, ...}: {
  services.tailscale = {
    enable = true;
    extraSetFlags = ["--accept-routes=true" "--operator=jaanonim"];
  };
  environment.systemPackages = with pkgs; [tail-tray];
  environment.etc."xdg/autostart/tail-tray.desktop".source = "${pkgs.tail-tray}/share/applications/tail-tray.desktop";
}
