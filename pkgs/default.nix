{
  inputs,
  system,
  pkgs,
  lib,
  ...
}: let
  packageFiles =
    builtins.attrNames (removeAttrs (builtins.readDir ./.) ["default.nix"]);
  unfreeFiles = ["rider.nix"];

  includeUnfree = pkgs.config.allowUnfree or false;

  filteredPackageFiles =
    if includeUnfree
    then packageFiles
    else builtins.filter (path: !(builtins.elem path unfreeFiles)) packageFiles;
in
  {
    nsearch = inputs.nsearch.packages.${system}.default;
  }
  // (
    lib.foldl (a: b: a // b) {}
    (
      map (path: import "${./.}/${path}" {inherit pkgs lib;}) filteredPackageFiles
    )
  )
