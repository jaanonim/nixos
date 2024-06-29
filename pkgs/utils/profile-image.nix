{stdenv, ...}: let
  pname = "profile-image";
in
  stdenv.mkDerivation {
    inherit pname;
    src = ../../../config;
    installPhase = ''
      mkdir -p $out
      cp profile.png $out/profile.png
    '';
  }
