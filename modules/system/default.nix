_: {
  imports = builtins.map (path: ./. + /${path}) (builtins.attrNames (builtins.removeAttrs (builtins.readDir ./.) ["default.nix"]));
}
