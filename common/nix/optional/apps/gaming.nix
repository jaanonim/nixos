{pkgs, ...}: let
  myPrismlauncher =
    (import (builtins.fetchTarball {
      url = "https://github.com/NixOS/nixpkgs/archive/05bbf675397d5366259409139039af8077d695ce.tar.gz";
      sha256 = "1r26vjqmzgphfnby5lkfihz6i3y70hq84bpkwd43qjjvgxkcyki0";
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
