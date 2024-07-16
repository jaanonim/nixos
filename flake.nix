{
  description = "Nixos config flake";

  inputs = {
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

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

    vscode-server = {
      url = "github:nix-community/nixos-vscode-server";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    bible-runner = {
      url = "github:jaanonim/BibleRunner-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
    specialArgs = {inherit inputs outputs configLib nixpkgs lib self;};
  in {
    overlays = import ./overlays {inherit inputs;};

    packages =
      forAllSystems
      (
        system: let
          pkgs = nixpkgs.legacyPackages.${system};
        in
          import ./pkgs {inherit pkgs;}
      );

    nixosModules = import ./modules/nixos;

    homeManagerModules = import ./modules/home-manager;

    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

    devShells = forAllSystems (system: import ./shell.nix nixpkgs.legacyPackages.${system});

    checks.x86_64-linux = import ./checks inputs;

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
