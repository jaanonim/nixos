{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.my.stylix;
in {
  options.my.stylix = {
    enable = mkEnableOption "stylix";
  };

  config = mkIf cfg.enable {
    stylix = {
      enable = true;
      autoEnable = true;
    };
  };
}
