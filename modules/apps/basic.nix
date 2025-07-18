{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  inherit (config) my;
in {
  config = mkIf (builtins.any (ele: (ele == (lib.removeSuffix ".nix" (baseNameOf __curPos.file)))) my.apps) {
    my._packages = with pkgs; [
      kdePackages.kate
      kdePackages.ark
      kdePackages.okular
      kdePackages.gwenview
      vlc
      libvlc
      brave
      gnome-calculator
      youtube-music
    ];
    programs.chromium.extraOpts.IncognitoModeAvailability = 1;
  };
}
