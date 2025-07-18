{
  lib,
  config,
  ...
}:
with lib; let
  inherit (config) my;
  cfg = config.my.ssh;
in {
  options.my.ssh = {
    enable = mkEnableOption "ssh server";
    insertPrivKeys = mkEnableOption "insertion of private keys to be used for auth";
  };

  config = {
    assertions = [
      {
        assertion = cfg.insertPrivKeys -> (my.sops && my.homeManager);
        message = "sops and home manager need to be enabled to insert private keys";
      }
    ];
    services.openssh = {
      enable = cfg.enable;
      settings.PasswordAuthentication = !(my.sops && my.homeManager);
    };
    #TODO: fix
    # users.users.${my.mainUser} = mkIf cfg.enable {
    #   openssh.authorizedKeys.keyFiles = [
    #     "${my.homeDirectory}/.ssh/id_ed25519.pub"
    #   ];
    # };

    home-manager.users.${my.mainUser} = mkIf (my.sops && my.homeManager) {
      sops.secrets = {
        "ssh-keys/jaanonim/rsa/private" = mkIf cfg.insertPrivKeys {
          path = "${my.homeDirectory}/.ssh/id_rsa";
        };
        "ssh-keys/jaanonim/rsa/public" = {
          path = "${my.homeDirectory}/.ssh/id_rsa.pub";
        };
        "ssh-keys/jaanonim/ed25519/private" = mkIf cfg.insertPrivKeys {
          path = "${my.homeDirectory}/.ssh/id_ed25519";
        };
        "ssh-keys/jaanonim/ed25519/public" = {
          path = "${my.homeDirectory}/.ssh/id_ed25519.pub";
        };
      };
    };
  };
}
