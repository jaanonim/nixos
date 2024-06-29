{pkgs, ...}: {
  discord-autostart = pkgs.callPackage ./utils/discord-autostart.nix {};
  profile-image = pkgs.callPackage ./utils/profile-image.nix {};
}
