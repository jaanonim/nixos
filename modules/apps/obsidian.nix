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
      obsidian
      git
    ];

    environment.etc."xdg/autostart/obsidian.desktop".source = "${pkgs.obsidian}/share/applications/obsidian.desktop";
  };
}
