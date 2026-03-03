_: {
  imports = map (path: ./. + /${path}) (builtins.attrNames (removeAttrs (builtins.readDir ./.) ["default.nix"]));
}
