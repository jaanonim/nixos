{
  lib,
  config,
  ...
}:
with lib; let
  my = config.my;
in {
  options.my = {
    terminal = mkOption {
      type = types.package;
      default = pkgs.ghostty;
      description = "Default terminal emulator";
    };
  };

  config = mkIf my.desktop.enable {
    environment.defaultPackages = [terminal];
  };
}
