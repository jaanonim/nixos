{inputs, ...}: let
  secrets-path = builtins.toString inputs.jaanonim-secrets;
  certificates-path = "${secrets-path}/certificate";
  certificate-files = builtins.map (name: "${certificates-path}/${name}") (builtins.attrNames (builtins.readDir certificates-path));
in {
  security.pki.certificateFiles = certificate-files;
}
