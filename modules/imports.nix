{
  system,
  inputs,
  ...
}: [
  inputs.stylix.nixosModules.stylix
  inputs.sops-nix.nixosModules.sops
  inputs.probe-rs-rules.nixosModules.${system}.default
  inputs.home-manager.nixosModules.default
  inputs.lanzaboote.nixosModules.lanzaboote
]
