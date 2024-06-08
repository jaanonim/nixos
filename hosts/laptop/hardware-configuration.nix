# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{lib, ...}: {
  imports = [];

  boot.initrd.availableKernelModules = ["ata_piix" "ohci_pci" "sd_mod" "sr_mod"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = [];
  boot.extraModulePackages = [];

  # fileSystems."/" = {
  #   device = "/dev/disk/by-uuid/ba7e9bdb-aad3-4cd1-8c51-ee131e7127af";
  #   fsType = "ext4";
  # };

  #  swapDevices = [{device = "/dev/disk/by-uuid/15643402-152b-4c7d-ba12-c7dc8ec2a8cf";}];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp0s3.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  virtualisation.virtualbox.guest.enable = true;
}
