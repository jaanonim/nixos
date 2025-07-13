{
  lib,
  config,
  ...
}: {
  imports = builtins.map (path: ./. + "/${path}") (builtins.attrNames (builtins.removeAttrs (builtins.readDir ./.) ["default.nix"]));

  options = {
    flakePart = {
      nixosConfigurations = lib.mkOption {
        type = lib.types.attrs;
        description = "Set of nixos configurations for the flake.";
      };
    };
  };

  config.flake = config.flakePart;
}
