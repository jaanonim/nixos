{pkgs, ...}: {
  packages = with pkgs; [
    steam
    (lutris.override {extraLibraries = pkgs: [pkgs.libunwind];})
    prismlauncher
  ];
}
