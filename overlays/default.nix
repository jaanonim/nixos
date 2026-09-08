_: {
  modifications = final: prev: {
    nixos-firewall-tool = prev.nixos-firewall-tool.overrideAttrs (oldAttrs: {
      patches = (oldAttrs.patches or []) ++ [./patches/nixos-firewall-tool.patch];
    });
  };
}
