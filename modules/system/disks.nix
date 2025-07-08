_: {
  fileSystems."/mnt/dane" = {
    device = "/dev/disk/by-uuid/ee53362c-cad2-4ac1-9060-02c868233572";
    fsType = "ext4";
    options = ["users" "nofail" "exec"];
  };
}
