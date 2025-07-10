{
  inputs,
  config,
  lib,
  ...
}:
with lib; let
  secrets-path = builtins.toString inputs.jaanonim-secrets;
  my = config.my;
in {
  options.my = {
    sops = mkEnableOption "sops";
  };

  imports = mkIf my.sops [inputs.sops-nix.nixosModules.sops];

  config = mkIf my.sops {
    sops = {
      defaultSopsFile = "${secrets-path}/secrets.yaml";

      age = {
        sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
        keyFile = "/var/lib/sops-nix/key.txt";
        generateKey = true;
      };
    };

    home-manager.users.${my.mainUser} = mkIf my.homeManager {
      imports = [inputs.sops-nix.homeManagerModules.sops];
      sops = {
        defaultSopsFile = "${secrets-path}/secrets.yaml";

        age.keyFile = "${my.homeDirectory}/.config/sops/age/keys.txt";

        secrets = {
          "ssh-keys/jaanonim/rsa/private" = {
            path = "${my.homeDirectory}/.ssh/id_rsa";
          };
          "ssh-keys/jaanonim/rsa/public" = {
            path = "${my.homeDirectory}/.ssh/id_rsa.pub";
          };
          "ssh-keys/jaanonim/ed25519/private" = {
            path = "${my.homeDirectory}/.ssh/id_ed25519";
          };
          "ssh-keys/jaanonim/ed25519/public" = {
            path = "${my.homeDirectory}/.ssh/id_ed25519.pub";
          };
        };
      };
    };
  };
}
