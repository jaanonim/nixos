_: {
  boot.supportedFilesystems = ["ntfs"];
  fileSystems."/mnt/dane" = {
    device = "/dev/disk/by-uuid/0C2A2C6F2A2C57CA";
    fsType = "ntfs-3g";
    options = ["rw" "uid=1000" "gid=1000" "umask=0022" "auto"];
  };
}
