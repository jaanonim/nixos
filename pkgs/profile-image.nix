{pkgs, ...}:
pkgs.stdenv.mkDerivation {
  name = "profile-image";
  src = ../../config;
  installPhase = ''
    mkdir -p $out
    cp profile.png $out/profile.png
  '';
}
