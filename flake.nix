{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    plasma-manager = {
      url = "github:pjones/plasma-manager";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };

    stylix = {
      url = "github:danth/stylix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };

    vscode-server.url = "github:nix-community/nixos-vscode-server";
  };

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    inherit (self) outputs;
    inherit (nixpkgs) lib;

    system = "x86_64-linux";
    forAllSystems = nixpkgs.lib.genAttrs [
      "x86_64-linux"
    ];

    configLib = import ./lib {inherit inputs lib;};
    specialArgs = {inherit inputs outputs configLib nixpkgs lib;};
  in {
    overlays = import ./overlays {inherit inputs;};

    nixosModules = import ./modules/nixos;

    homeManagerModules = import ./modules/home-manager;

    packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});

    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

    devShells = forAllSystems (system: import ./shell.nix nixpkgs.legacyPackages.${system});

    nixosConfigurations = {
      laptop = lib.nixosSystem {
        inherit system;
        inherit specialArgs;
        modules = [./hosts/laptop];
      };

      virtualbox = lib.nixosSystem {
        inherit system;
        inherit specialArgs;
        modules = [
          ./hosts/virtualbox
          ./hosts/laptop
        ];
      };
    };
  };
}
