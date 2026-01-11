{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  inherit (config) my;
  cfg = my.yubikey;
in {
  options.my.yubikey = {
    enable = mkEnableOption "yubikey";
  };
  config = mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.yubikey-manager
      pkgs.pam_u2f
      pkgs.yubioath-flutter
    ];

    services.pcscd.enable = true;
    services.udev.packages = [pkgs.yubikey-personalization];

    security.pam.services = {
      login.u2fAuth = true;
      sudo.u2fAuth = true;
    };
    security.pam.u2f = {
      enable = true;
      settings = {
        authFile = config.sops.secrets."yubikeys/${my.mainUser}".path;
        interactive = true;
        cue = true;
      };
    };

    sops.secrets."yubikeys/${my.mainUser}" = mkIf my.sops {
      owner = my.mainUser;
      path = "${my.homeDirectory}/.config/Yubico/u2f_keys";
    };
  };
}
