final: prev: {
  pkgs.alejandra.overrideAttrs = {
    patches = [./patch/alejandra.patch];
    doCheck = false;
  };
}
