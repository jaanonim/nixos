{
  inputs,
  config,
  ...
}: let
  secrets-path = builtins.toString inputs.jaanonim-secrets;
in {
  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];

  sops = {
    defaultSopsFile = "${secrets-path}/secrets.yaml";

    age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";

    secrets = {
      "ssh-keys/jaanonim/rsa/private" = {
        path = "${config.home.homeDirectory}/.ssh/id_rsa";
      };
      "ssh-keys/jaanonim/rsa/public" = {
        path = "${config.home.homeDirectory}/.ssh/id_rsa.pub";
      };
      "ssh-keys/jaanonim/ed25519/private" = {
        path = "${config.home.homeDirectory}/.ssh/id_ed25519";
      };
      "ssh-keys/jaanonim/ed25519/public" = {
        path = "${config.home.homeDirectory}/.ssh/id_ed25519.pub";
      };
      "wakatime-api" = {};
    };
  };
}
