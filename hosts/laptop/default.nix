# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  inputs,
  configLib,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    configLib.core
    (configLib.optional /teminal.nix)
    (configLib.optional /plasma.nix)
#    (configLib.optional /devices.nix)
    (configLib.optional /flatpack.nix)
    (configLib.optional /virtualbox.nix)

    (configLib.users /jaanonim.nix)
    ./colors.nix
  ];

  networking.hostName = "laptop";

  virtualisation.docker.enable = true;

  #home-manager = {
  #  extraSpecialArgs = {inherit inputs;};
  #  sharedModules = [inputs.plasma-manager.homeManagerModules.plasma-manager];
  #  users = {"jaanonim" = import ./home.nix;};
  #};

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
