{
  lib,
  config,
  ...
}:
with lib; let
  inherit (config) my;
  cfg = my.stylix;
in {
  options.my.stylix = {
    enable = mkEnableOption "stylix";
  };

  config = mkIf cfg.enable {
    stylix = {
      enable = true;
      autoEnable = true;
    };
    qt.platformTheme = lib.mkForce "kde"; # fix for https://github.com/nix-community/stylix/issues/1865
    home-manager.users.${my.mainUser} = mkIf my.homeManager {
      home.pointerCursor.enable = true;
    };
  };
}
