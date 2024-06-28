{pkgs, ...}: ((pkgs.stdenv.mkDerivation {
    name = "ProfileImage";
    src = ../../../config;
    installPhase = ''
      mkdir -p $out
      cp profile.png $out/profile.png
    '';
  })
  + /profile.png)
