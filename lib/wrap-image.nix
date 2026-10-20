{pkgs, ...}: path: let
  drv = pkgs.stdenv.mkDerivation {
    name = "${path}-image";
    src = ../config;
    installPhase = ''
      mkdir -p $out
      cp ${path} $out/${path}
    '';
  };
in "${drv}/${path}"
