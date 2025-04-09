{pkgs, ...}: let
  user = "jaanonim";
  platform = "amd";
  vfioIds = ["10de:25a2"];
in {
  boot = {
    kernelModules = ["kvm-${platform}" "vfio_virqfd" "vfio_pci" "vfio_iommu_type1" "vfio"];
    kernelParams = ["${platform}_iommu=on" "${platform}_iommu=pt" "kvm.ignore_msrs=1"];
    extraModprobeConfig = "options vfio-pci ids=${builtins.concatStringsSep "," vfioIds}";
  };

  systemd.tmpfiles.rules = [
    "f /dev/shm/looking-glass 0660 ${user} qemu-libvirtd -"
  ];

  environment.systemPackages = with pkgs; [
    virt-manager
    looking-glass-client
  ];

  virtualisation = {
    libvirtd = {
      enable = true;

      onBoot = "ignore";
      onShutdown = "shutdown";

      qemu = {
        package = pkgs.qemu_kvm;
        ovmf.enable = true;
      };
    };
  };

  users.users.${user}.extraGroups = ["qemu-libvirtd" "libvirtd" "disk"];
}
