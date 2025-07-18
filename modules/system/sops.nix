{
  inputs,
  config,
  lib,
  ...
}:
with lib; let
  secrets-path = builtins.toString inputs.jaanonim-secrets;
  inherit (config) my;
in {
  options.my = {
    sops = mkEnableOption "sops";
    setPassword = mkEnableOption "password for main user from sops";
  };

  config = mkIf my.sops {
    sops = {
      defaultSopsFile = "${secrets-path}/secrets.yaml";

      age = {
        sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
        keyFile = "/var/lib/sops-nix/key.txt";
        generateKey = true;
      };
      secrets = mkIf my.setPassword {
        "${my.mainUser}-password".neededForUsers = true;
      };
    };

    users = mkIf my.setPassword {
      mutableUsers = false;
      users.${my.mainUser}.hashedPasswordFile = config.sops.secrets."${my.mainUser}-password".path;
    };

    home-manager.users.${my.mainUser} = mkIf my.homeManager {
      imports = [inputs.sops-nix.homeManagerModules.sops];
      sops = {
        defaultSopsFile = "${secrets-path}/secrets.yaml";
        age.keyFile = "${my.homeDirectory}/.config/sops/age/keys.txt";
      };
    };
  };
}
