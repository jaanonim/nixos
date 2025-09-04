{
  lib,
  pkgs,
  ...
}: let
  pkg = pkgs.stdenv.mkDerivation {
    name = "plasma-desktop-appletsrc";
    src = lib.root /config;
    installPhase = ''
      mkdir -p $out
      cp plasma-org.kde.plasma.desktop-appletsrc $out/plasma-org.kde.plasma.desktop-appletsrc
      sed -i"" 's,@@ICON@@,${lib.profileImage}/profile.png,g' $out/plasma-org.kde.plasma.desktop-appletsrc
    '';
  };
in {
  home.file.".config/plasma-org.kde.plasma.desktop-appletsrc".source = "${pkg}/plasma-org.kde.plasma.desktop-appletsrc";
}
