{
  pkgs,
  config,
  ...
}: let
  gpu-pci-address = "0000:01:00.0";
  gpu-pci-id = "10de 25a2";
  user = "jaanonim";

  run-vm = pkgs.writeShellScriptBin "run-vm" ''
    set -e

    if [ -z "$1" ]; then
      echo "No disk image path provided. Using default: /mnt/dane/Virtual/windows10.qcow2"
      DISK_IMAGE="/mnt/dane/Virtual/windows10.qcow2"
    else
      DISK_IMAGE="$1"
    fi

    ${bind-vm}/bin/bind-vm

    echo "Starting Windows 10 VM with disk image: ''${DISK_IMAGE} …"
    qemu-system-x86_64 \
      -enable-kvm \
      -m 16G \
      -cpu host,kvm=on,+topoext \
      -smp 6 \
      -device vfio-pci,host=${gpu-pci-address},rombar=0 \
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
    ${unbind-vm}/bin/unbind-vm
  '';

  bind-vm = pkgs.writeShellScriptBin "bind-vm" ''
    set -e

    echo "Switching GPU to VFIO for VM usage …"
    if [ -L /sys/bus/pci/devices/${gpu-pci-address}/driver ]; then
      echo "Unbinding device ${gpu-pci-address} from its host driver."
      sudo -i -u ${user} lsof /dev/nvidia* |awk 'NR > 1 {print $2}' |xargs kill -9 || true
      modprobe -r nvidia_drm nvidia_modeset nvidia_uvm nvidia
      echo ${gpu-pci-address} > /sys/bus/pci/devices/${gpu-pci-address}/driver/unbind || true
      echo "Unbinding successfully"
    else
      echo "Device ${gpu-pci-address} is not currently bound to any driver."
    fi

    echo "Binding device to vfio-pci …"
    modprobe -i vfio_pci vfio_pci_core vfio_iommu_type1
    echo "${gpu-pci-id}" > /sys/bus/pci/drivers/vfio-pci/new_id || true
  '';

  unbind-vm = pkgs.writeShellScriptBin "unbind-vm" ''
    set -e

    echo "VM has exited. Switching GPU back to the NVIDIA driver …"
    modprobe -r vfio_pci vfio_pci_core vfio_iommu_type1
    echo ${gpu-pci-address}> /sys/bus/pci/drivers/vfio-pci/unbind || true
    modprobe -i nvidia_drm nvidia_modeset nvidia_uvm nvidia
    echo "" > /sys/bus/pci/devices/${gpu-pci-address}/driver_override || true
    echo ${gpu-pci-address} > /sys/bus/pci/drivers/nvidia/bind || true
    echo "GPU has been rebound to the NVIDIA driver."
  '';

  start-vm = pkgs.writeShellScriptBin "start-vm" ''
    sudo ${run-vm}/bin/run-vm "$@" &
    SWITCH_PID=$!
    sleep 10
    echo "Launching Looking Glass client …"
    looking-glass-client -c /etc/xdg/looking-glass-client.ini &
    wait ''${SWITCH_PID}
  '';
in {
  boot.extraModulePackages = with config.boot.kernelPackages; [
    kvmfr
  ];

  boot.kernelParams = [
    "amd_iommu=on"
    "iommu=pt"
    "kvmfr.static_size_mb=32"
  ];

  boot.kernelModules = [
    "vfio"
    "vfio_iommu_type1"
    "vfio_pci"
    "vfio_virqfd"
    "kvmfr"
  ];

  virtualisation.libvirtd.qemu = {
    package = pkgs.qemu_kvm;
  };

  environment.systemPackages = with pkgs; [
    qemu_kvm
    looking-glass-client
    start-vm
    bind-vm
    unbind-vm
  ];

  environment.etc."looking-glass-client.ini".text = ''
    [win]
    showFPS = yes
    [input]
    escapeKey = KEY_RIGHTCTRL
  '';

  services.udev.extraRules = ''
    SUBSYSTEM=="kvmfr", OWNER="${user}", GROUP="kvm", MODE="0660"
  '';
}
