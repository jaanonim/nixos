_: {
  networking = {
    enableIPv6 = true;
    networkmanager.enable = true;
    firewall.enable = true;
    nameservers = ["192.168.1.150" "1.1.1.1" "1.0.0.1"];
  };
  systemd.services.NetworkManager-wait-online.enable = false;
}
