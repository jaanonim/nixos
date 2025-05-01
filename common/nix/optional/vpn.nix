{pkgs, ...}: {
  services.tailscale = {
    enable = true;
    extraSetFlags = ["--accept-routes=true" "--operator=jaanonim"];
  };
  environment.systemPackages = with pkgs; [tail-tray];
}
