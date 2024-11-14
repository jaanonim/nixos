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

    ### Just for virtualbox

    vscode-server = {
      url = "github:nix-community/nixos-vscode-server";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ### My packages

    jaanonim-secrets = {
      url = "git+ssh://git@github.com/jaanonim/nixos-secrets.git?shallow=1";
      flake = false;
    };

    bible-runner = {
      url = "github:jaanonim/BibleRunner-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    creator = {
      url = "github:jaanonim/creator";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    forklab = {
      url = "github:jaanonim/forklab";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nsearch = {
      url = "github:niksingh710/nsearch";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    probe-rs-rules.url = "github:jneem/probe-rs-rules";
  };

  ### Outputs

  outputs = {
    self,
    nixpkgs,
    nixos-hardware,
    probe-rs-rules,
    ...
  } @ inputs: let
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

    basicInputs = {
      inherit inputs lib;
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    };

    configLib = import ./lib basicInputs;
    specialArgs = {
      inherit inputs outputs configLib nixpkgs lib self configModules;
      jaanonim-pkgs =
        {
          jaanonim-secrets = inputs.jaanonim-secrets.packages.${system}.default;
          bible-runner = inputs.bible-runner.packages.${system}.default;
          creator = inputs.creator.packages.${system}.default;
          forklab = inputs.forklab.packages.${system}.default;
          nsearch = inputs.nsearch.packages.${system}.default;
        }
        // (import ./overlays/pkgs basicInputs);
    };
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

    nixosModules = configModules.home;

    homeManagerModules = configModules.nix;

    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

    devShells = forAllSystems (system: import ./shell.nix nixpkgs.legacyPackages.${system});

    checks.x86_64-linux = import ./checks inputs;

    nixosConfigurations = {
      laptop = lib.nixosSystem {
        inherit system specialArgs;
        modules = [
          nixos-hardware.nixosModules.lenovo-ideapad-15ach6
          probe-rs-rules.nixosModules.${system}.default
          ./hosts/laptop
        ];
      };

      virtualbox = lib.nixosSystem {
        inherit system specialArgs;
        modules = [
          ./hosts/virtualbox
          ./hosts/laptop
        ];
      };

      iso = lib.nixosSystem {
        inherit system specialArgs;
        modules = [
          ./hosts/iso
        ];
      };
    };
  };
}
