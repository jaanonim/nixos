_: {
  imports = builtins.attrNames (builtins.removeAttrs (builtins.readDir ./.) ["default.nix"]);
}
