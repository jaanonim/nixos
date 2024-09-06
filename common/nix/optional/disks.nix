_:{
  boot.supportedFilesystems = [ "ntfs" ];
   fileSystems."/mnt/dane" =
    { device = "/dev/nvme1n1p2";
      fsType = "ntfs-3g"; 
      options = [ "rw" "uid=1000"];
    };
}