{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:
with lib;
{
  imports = [ <nixpkgs/nixos/modules/installer/cd-dvd/channel.nix> <nixpkgs/nixos/modules/virtualisation/virtualbox-image.nix> <nixpkgs/nixos/modules/profiles/clone-config.nix> ];

  users.users.jaanonim.extraGroups = ["vboxsf"];

  boot.loader.grub.fsIdentifier = "provided";

  services.xserver.videoDrivers = mkOverride 40 [ "virtualbox" "vmware" "cirrus" "vesa" "modesetting" ];

  services.xserver.desktopManager.plasma5.enable = pkgs.lib.mkForce false;
  # services.xserver.displayManager.sddm.enable = lib.mkForce false;

  virtualisation.virtualbox.guest.enable = true;
  # virtualisation.virtualbox.guest.x11 = true;
}
