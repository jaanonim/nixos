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

    sops-nix = {
      url = "github:Mic92/sops-nix";
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

    jaanonim-pkgs = {
      url = "github:jaanonim/nix-pkgs";
      inputs.nixpkgs.follows = "nixpkgs";
    };


    jaanonim-secrets = {
      url = "git+file:///home/jaanonim/nixos-secrets";
      flake = false;
    };
  };

  outputs =
    { self
    , nixpkgs
    , nixos-hardware
    , ...
    } @ inputs:
    let
      inherit (self) outputs;
      inherit (nixpkgs) lib;

      system = "x86_64-linux";
      forAllSystems = nixpkgs.lib.genAttrs [
        "x86_64-linux"
      ];

      configModules = {
        home = import ./modules/home;
        nix = import ./modules/nix;
      };

      configLib = import ./lib { inherit inputs lib; };
      specialArgs = { inherit inputs outputs configLib nixpkgs lib self configModules; };
    in
    {
      overlays = import ./overlays { inherit inputs; };

      packages =
        forAllSystems
          (
            system:
            let
              pkgs = nixpkgs.legacyPackages.${system};
            in
            import ./pkgs { inherit pkgs; }
          );

      nixosModules = configModules.home;

      homeManagerModules = configModules.nix;

      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

      devShells = forAllSystems (system: import ./shell.nix nixpkgs.legacyPackages.${system});

      checks.x86_64-linux = import ./checks inputs;

      nixosConfigurations = {
        laptop = lib.nixosSystem {
          inherit system;
          specialArgs = specialArgs // { jaanonim-pkgs = inputs.jaanonim-pkgs.packages.${system}; };
          modules = [
            nixos-hardware.nixosModules.lenovo-ideapad-15ach6
            ./hosts/laptop
          ];
        };

        virtualbox = lib.nixosSystem {
          inherit system;
          specialArgs = specialArgs // { jaanonim-pkgs = inputs.jaanonim-pkgs.packages.${system}; };
          modules = [
            ./hosts/virtualbox
            ./hosts/laptop
          ];
        };

        iso = lib.nixosSystem {
          inherit system;
          specialArgs = specialArgs // { jaanonim-pkgs = inputs.jaanonim-pkgs.packages.${system}; };
          modules = [
            ./hosts/iso
          ];
        };
      };
    };
}
