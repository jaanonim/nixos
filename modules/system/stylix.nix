{
  lib,
  inputs,
  config,
  ...
}:
with lib; let
  cfg = config.my.stylix;
in {
  options.my.stylix = {
    enable = mkEnableOption "stylix";
  };

  imports = [inputs.stylix.nixosModules.stylix];

  config = mkIf cfg.enable {
    stylix = {
      enable = true;
      autoEnable = true;
    };
  };
}
