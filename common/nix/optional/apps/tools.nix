{pkgs, ...}: {
  packages = with pkgs; [
    emote
    pika-backup
    syncthing
    normcap
  ];
}
