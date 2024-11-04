{pkgs, ...}: let
  myPrismlauncher =
    (import (builtins.fetchTarball {
      url = "https://github.com/NixOS/nixpkgs/archive/05bbf675397d5366259409139039af8077d695ce.tar.gz";
    }) {})
    .prismlauncher;
in {
  programs.steam.enable = true;
  packages = with pkgs; [
    (lutris.override {
      extraLibraries = pkgs: [pkgs.libunwind];
      extraPkgs = pkgs: [pkgs.python3];
    })
    myPrismlauncher
  ];
}
