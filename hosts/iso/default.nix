{
  modulesPath,
  configLib,
  ...
}: {
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"

    (configLib.some_core /localization.nix)
    (configLib.some_core /nixos.nix)
    (configLib.some_core /zsh.nix)
    # (configLib.optional /teminal.nix)
  ];

  hardware.enableRedistributableFirmware = true;
}
