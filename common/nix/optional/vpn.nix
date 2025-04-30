_: {
  services.tailscale = {
    enable = true;
    extraSetFlags = ["--accept-routes=true"];
  };
}
