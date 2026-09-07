_: {
  modifications = final: prev: {
    nixos-firewall-tool = prev.nixos-firewall-tool.overrideAttrs (oldAttrs: {
      patches = (oldAttrs.patches or []) ++ [./patches/nixos-firewall-tool.patch];
    });
    # https://github.com/NixOS/nixpkgs/issues/560776
    vscode = prev.vscode.overrideAttrs (old: {
      postPatch =
        old.postPatch
        + ''
          ln -s node_modules resources/app/node_modules.asar.unpacked
        '';
    });
  };
}
