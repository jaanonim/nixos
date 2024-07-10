{pkgs, ...}:
pkgs.stdenv.mkDerivation {
  name = "obsidian-icon";
  src = ../../config;
  installPhase = ''
    mkdir -p $out
    cp obsidian-icon.svg $out/obsidian-icon.svg
  '';
}
