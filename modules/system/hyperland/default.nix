{
  lib,
  config,
  pkgs,
  inputs,
  ...
} @ args:
with lib; let
  inherit (config) my;
  cfg = config.my.desktop.hyperland;
in {
  options.my.desktop.hyperland = {
    enable = mkEnableOption "hyperland";
  };

  config = mkIf cfg.enable {
    programs.hyprland.enable = true;
    programs.hyprland.package = inputs.hyprland.packages."${pkgs.system}".hyprland;

    home-manager.users.${my.mainUser} = mkIf my.homeManager (import ./hm args);
  };
}
