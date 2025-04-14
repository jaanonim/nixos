{pkgs, ...}: let
  gpu-pci-address = "0000:01:00.0";
  gpu-pci-id = "10de 25a2";
  user = "jaanonim";

  run-vm = pkgs.writeShellScriptBin "run-vm" ''
    set -e
    ${bind-vm}/bin/bind-vm

    echo "Starting Windows 10 VM …"
    qemu-system-x86_64 \
      -enable-kvm \
      -m 16G \
      -cpu host,kvm=on \
      -smp 6 \
      -device vfio-pci,host=${gpu-pci-address},rombar=0 \
      -drive cache=none,file=/mnt/dane/Virtual/windows10.qcow2,format=qcow2 \
      -net nic -net user \
      -display none \
      -spice port=5900,disable-ticketing=on \
      -device ivshmem-plain,memdev=ivshmem,bus=pci.0 \
      -object memory-backend-file,id=ivshmem,share=on,mem-path=/dev/shm/looking-glass,size=32M \
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
      sudo -i -u ${user} lsof /dev/nvidia* |awk 'NR > 1 {print $2}' |xargs kill || true
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
    sudo ${run-vm}/bin/run-vm &
    SWITCH_PID=$!
    sleep 10
    echo "Launching Looking Glass client …"
    looking-glass-client -c /etc/xdg/looking-glass-client.ini &
    wait ''${SWITCH_PID}
  '';
in {
  # Enable AMD IOMMU and additional kernel parameters:
  boot.kernelParams = [
    "amd_iommu=on" # Enable AMD IOMMU support
    "iommu=pt" # Use pass-through mode for IOMMU
    "kvmfr.static_size_mb=32"
  ];

  # Load the VFIO kernel modules needed for PCI passthrough:
  boot.kernelModules = [
    "vfio"
    "vfio_iommu_type1"
    "vfio_pci"
    "vfio_virqfd"
    # "kvmfr"
  ];

  # Enable QEMU/KVM virtualization:
  virtualisation.libvirtd.qemu = {
    package = pkgs.qemu_kvm;
    # extraOptions = ["--enable-kvm"];
  };

  # Install the Looking Glass client if available.
  environment.systemPackages = with pkgs; [
    qemu_kvm
    looking-glass-client # Ensure this package exists in your channel; if not, you may need to build it manually.
    start-vm
    bind-vm
    unbind-vm
  ];

  # Add a basic Looking Glass client configuration file.
  # Adjust the values (frame dimensions, enabling the mouse cursor, etc.) to your setup.
  environment.etc."looking-glass-client.ini".text = ''
    [general]
    # The width and height should match the resolution set in your Windows VM’s Looking Glass server config.
    frame_width = 1920
    frame_height = 1080
    # Enable or disable the mouse cursor capture
    cursor = true
    # Other client options can be set here as needed.
    [win]
    showFPS = yes
    [input]
    escapeKey = KEY_RIGHTCTRL
  '';

  # Optionally, if you need to adjust shared memory permissions for Looking Glass, you can add a systemd tmpfiles rule.
  # This example creates the shared memory file with proper permissions if required by your Looking Glass setup.
  systemd.tmpfiles.rules = [
    "f /dev/shm/looking-glass 0660 ${user} kvm -"
  ];

  # services.udev.extraRules = ''
  #   SUBSYSTEM=="kvmfr", OWNER="${user}", GROUP="kvm", MODE="0660"
  # '';
}
