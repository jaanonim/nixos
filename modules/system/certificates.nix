{inputs, ...}: let
  secrets-path = toString inputs.jaanonim-secrets;
  certificates-path = "${secrets-path}/certificate";
  certificate-files = map (name: "${certificates-path}/${name}") (builtins.attrNames (builtins.readDir certificates-path));
in {
  security.pki.certificateFiles = certificate-files;
}
