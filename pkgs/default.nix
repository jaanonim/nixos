{
  inputs,
  system,
  pkgs,
  lib,
  ...
}:
{
  jaanonim-secrets = inputs.jaanonim-secrets.packages.${system}.default;
  bible-runner = inputs.bible-runner.packages.${system}.default;
  creator = inputs.creator.packages.${system}.default;
  forklab = inputs.forklab.packages.${system}.default;
  nsearch = inputs.nsearch.packages.${system}.default;
}
// (
  lib.foldl (a: b: a // b) {} (builtins.map (path: import "${./.}/${path}" {inherit pkgs lib;})
    (builtins.attrNames (builtins.removeAttrs (builtins.readDir ./.) ["default.nix"])))
)
