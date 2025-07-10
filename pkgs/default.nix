args: builtins.foldl' (a: b: a // b) {} (builtins.map (path: import "${./.}/${path}" args) (builtins.attrNames (builtins.removeAttrs (builtins.readDir ./.) ["default.nix"])))
