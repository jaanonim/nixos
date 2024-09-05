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
      "ssh-keys/jaanonim/private" = {
        path = "${config.home.homeDirectory}/.ssh/id_rsa";
      };
      "ssh-keys/jaanonim/public" = {
        path = "${config.home.homeDirectory}/.ssh/id_rsa.pub";
      };
      "wakatime-api" = {};
    };
  };
}
