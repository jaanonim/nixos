{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  inherit (config) my;
  cfg = config.my.vfio;
in {
  options.my.vfio = {
    enable = mkEnableOption "vifo - gpu vm passthrough";
    gpuPciAddress = mkOption {
      type = types.str;
      example = "0000:01:00.0";
      description = "PCI address for gpu";
    };
    gpuPciId = mkOption {
      type = types.str;
      example = "10de 25a2";
      description = "PCI id for gpu";
    };

    vm = {
      defaultImage = mkOption {
        type = types.str;
        example = "/mnt/dane/Virtual/windows10.qcow2";
        description = "Path to image that will be booted by default.";
      };
      cpu = mkOption {
        type = types.str;
        default = "6";
        description = "Number of cpu cores for vm.";
      };
      ram = mkOption {
        type = types.str;
        default = "16G";
        description = "Amount of memory for vm.";
      };
    };
  };

  config = mkIf cfg.enable (let
    vm-kill-gpu = pkgs.writeShellScriptBin "vm-kill-gpu" ''
      lsof /dev/nvidia* |awk 'NR > 1 {print $2}' |xargs kill -9
    '';

    vm-start = pkgs.writeShellScriptBin "vm-start" ''
      set -e

      if [ -z "$1" ]; then
        echo "No disk image path provided. Using default: ${cfg.vm.defaultImage}"
        DISK_IMAGE="${cfg.vm.defaultImage}"
      else
        DISK_IMAGE="$1"
      fi

      ${vm-bind}/bin/vm-bind

      echo "Starting Windows 10 VM with disk image: ''${DISK_IMAGE} …"
      qemu-system-x86_64 \
        -enable-kvm \
        -m ${cfg.vm.ram} \
        -cpu host,kvm=on,+topoext \
        -smp ${cfg.vm.cpu} \
        -device vfio-pci,host=${cfg.gpuPciAddress},rombar=0 \
        -drive cache=none,file=''${DISK_IMAGE},format=qcow2 \
        -net nic -net user \
        -display none \
        -spice port=5900,disable-ticketing=on \
        -device ivshmem-plain,id=shmem0,memdev=looking-glass \
        -object memory-backend-file,id=looking-glass,mem-path=/dev/kvmfr0,size=32M,share=yes \
        -audiodev spice,id=audio0 \
        -device ich9-intel-hda \
        -device hda-duplex,audiodev=audio0 \
        -device virtio-serial-pci \
        -chardev spicevmc,id=vdagent,name=vdagent \
        -device virtserialport,chardev=vdagent,name=com.redhat.spice.0 &

      VM_PID=$!
      echo "VM started with PID ''${VM_PID} – waiting for it to exit …"
      wait ''${VM_PID}

      sleep 2
      ${vm-unbind}/bin/vm-unbind
    '';

    vm-bind = pkgs.writeShellScriptBin "vm-bind" ''
      set -e

      echo "Switching GPU to VFIO for VM usage …"
      if [ -L /sys/bus/pci/devices/${cfg.gpuPciAddress}/driver ]; then
        echo "Unbinding device ${cfg.gpuPciAddress} from its host driver."
        sudo -i -u ${my.mainUser} lsof /dev/nvidia* |awk 'NR > 1 {print $2}' |xargs kill -9 || true
        modprobe -r nvidia_drm nvidia_modeset nvidia_uvm nvidia
        echo ${cfg.gpuPciAddress} > /sys/bus/pci/devices/${cfg.gpuPciAddress}/driver/unbind || true
        echo "Unbinding successfully"
      else
        echo "Device ${cfg.gpuPciAddress} is not currently bound to any driver."
      fi

      echo "Binding device to vfio-pci …"
      modprobe -i vfio_pci vfio_pci_core vfio_iommu_type1
      echo "${cfg.gpuPciId}" > /sys/bus/pci/drivers/vfio-pci/new_id || true
    '';

    vm-unbind = pkgs.writeShellScriptBin "vm-unbind" ''
      set -e

      echo "VM has exited. Switching GPU back to the NVIDIA driver …"
      modprobe -r vfio_pci vfio_pci_core vfio_iommu_type1
      echo ${cfg.gpuPciAddress}> /sys/bus/pci/drivers/vfio-pci/unbind || true
      modprobe -i nvidia_drm nvidia_modeset nvidia_uvm nvidia
      echo "" > /sys/bus/pci/devices/${cfg.gpuPciAddress}/driver_override || true
      echo ${cfg.gpuPciAddress} > /sys/bus/pci/drivers/nvidia/bind || true
      echo "GPU has been rebound to the NVIDIA driver."
    '';

    vm-run = pkgs.writeShellScriptBin "vm-run" ''
      sudo ${vm-start}/bin/vm-start "$@" &
      SWITCH_PID=$!
      sleep 10
      echo "Launching Looking Glass client …"
      looking-glass-client -c /etc/xdg/looking-glass-client.ini &
      wait ''${SWITCH_PID}
    '';
  in {
    boot = {
      extraModulePackages = with config.boot.kernelPackages; [
        kvmfr
      ];

      kernelParams = [
        "amd_iommu=on"
        "iommu=pt"
        "kvmfr.static_size_mb=32"
      ];

      kernelModules = [
        "vfio"
        "vfio_iommu_type1"
        "vfio_pci"
        "vfio_virqfd"
        "kvmfr"
      ];
    };

    virtualisation.libvirtd.qemu = {
      package = pkgs.qemu_kvm;
    };

    environment.systemPackages = with pkgs; [
      qemu_kvm
      looking-glass-client
      vm-run
      vm-bind
      vm-unbind
      vm-kill-gpu
    ];

    environment.etc."looking-glass-client.ini".text = ''
      [win]
      showFPS = yes
      [input]
      escapeKey = KEY_RIGHTCTRL
    '';

    services.udev.extraRules = ''
      SUBSYSTEM=="kvmfr", OWNER="${my.mainUser}", GROUP="kvm", MODE="0660"
    '';

    users.extraGroups.kvm.members = [my.mainUser];
  });
}
