{
  pkgs,
  lib,
  ...
}:
with lib; {
  imports = [
    (fetchTarball "https://github.com/nix-community/nixos-vscode-server/tarball/master")
    <nixpkgs/nixos/modules/virtualisation/virtualbox-image.nix>
  ];

  users.users.jaanonim.extraGroups = ["vboxsf"];

  boot.loader.grub.fsIdentifier = "provided";

  services = {
    xserver = {
      videoDrivers = mkOverride 40 ["virtualbox" "vmware" "cirrus" "vesa" "modesetting"];

      desktopManager.plasma5.enable = pkgs.lib.mkForce false;
    };

    # VScode ssh access
    openssh.enable = true;
    vscode-server.enable = true;
  };
  # services.xserver.displayManager.sddm.enable = lib.mkForce false;

  virtualisation.virtualbox.guest = {
    enable = true;
    clipboard = true;
    seamless = true;
  };
  # virtualisation.virtualbox.guest.x11 = true;

  # home-manager.users.jaanonim.services.vscode-server.enable = true;
}
