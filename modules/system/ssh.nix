{
  lib,
  config,
  inputs,
  pkgs,
  ...
}:
with lib; let
  inherit (config) my;
  cfg = config.my.ssh;
  secrets-path = builtins.toString inputs.jaanonim-secrets;
  ssh-path = "${secrets-path}/ssh/${my.mainUser}";
  ssh-filenames = builtins.attrNames (builtins.readDir ssh-path);
  ssh-files = builtins.map (name: "${ssh-path}/${name}") ssh-filenames;
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
      inherit (cfg) enable;
      settings.PasswordAuthentication = !(my.sops && my.homeManager);
    };

    environment.systemPackages = [pkgs.ghostty.terminfo];

    users.users.${my.mainUser} = mkIf cfg.enable {
      openssh.authorizedKeys.keys = builtins.map builtins.readFile ssh-files;
    };

    home-manager.users.${my.mainUser} = mkIf (my.sops && my.homeManager) {
      sops.secrets = {
        "ssh-keys/${my.mainUser}/rsa/private" = mkIf cfg.insertPrivKeys {
          path = "${my.homeDirectory}/.ssh/id_rsa";
        };
        "ssh-keys/${my.mainUser}/ed25519/private" = mkIf cfg.insertPrivKeys {
          path = "${my.homeDirectory}/.ssh/id_ed25519";
        };
      };
      home.file = recursiveMergeAttrs (builtins.map (name: {".ssh/${name}" = {source = "${ssh-path}/${name}";};}) ssh-filenames);
    };
  };
}
