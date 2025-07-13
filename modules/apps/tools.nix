{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  my = config.my;
in {
  config = mkIf (builtins.any (ele: (ele == (lib.removeSuffix ".nix" (baseNameOf __curPos.file)))) my.apps) (let
    normcapDesktop = pkgs.makeDesktopItem {
      name = "com.github.dynobo.normcap";
      desktopName = "NormCap";
      genericName = "OCR powered screen-capture tool";
      comment = "Extract text from an image directly into clipboard";
      exec = "${pkgs.normcap}/bin/normcap";
      icon = "${pkgs.normcap}/lib/python3.12/site-packages/normcap/resources/icons/normcap.png";
      terminal = false;
      categories = ["Utility" "Office"];
      keywords = ["Text" "Extraction" "OCR"];
    };
  in {
    my._packages = with pkgs; [
      emote
      pika-backup
      helvum
      normcap
      normcapDesktop
    ];
  });
}
