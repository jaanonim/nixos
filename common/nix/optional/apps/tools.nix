{pkgs, ...}: {
  packages = with pkgs; [
    emote
    pika-backup
    normcap
  ];
}
