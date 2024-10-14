{pkgs, ...}: {
  packages = with pkgs; [
    steam
    (lutris.override {
      extraLibraries = pkgs: [pkgs.libunwind];
      extraPkgs = pkgs: [pkgs.python3];
    })
    prismlauncher
  ];
}
