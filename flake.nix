{
  description = "Jaanonim's nixos config flake";

  inputs = {
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

    lanzaboote = {
      url = "github:nix-community/lanzaboote";
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
      inputs.nixpkgs.follows = "nixpkgs";
    };

    tt-schemes = {
      url = "github:tinted-theming/schemes";
      flake = false;
    };

    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    probe-rs-rules.url = "github:jneem/probe-rs-rules";

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
  };

  ### Outputs

  outputs = inputs @ {flake-parts, ...}: let
    # https://nixos.zulipchat.com/#narrow/stream/419910-flake-parts/topic/Overriding.20.60lib.60.20in.20flake-parts
    specialArgs = {
      lib = inputs.nixpkgs.lib.extend (_: _: (import ./lib {inherit inputs;}));
    };
  in
    flake-parts.lib.mkFlake {inherit inputs specialArgs;} {
      imports = [
        ./hosts
      ];

      systems = ["x86_64-linux" "aarch64-linux"];

      perSystem = {
        pkgs,
        inputs',
        system,
        ...
      }: {
        devShells.default = import ./shell.nix {
          inherit pkgs;
          inputs = inputs';
        };
        checks = import ./checks {
          inherit system pkgs inputs;
        };
        packages = {docs = pkgs.callPackage ./docs {} {inherit inputs pkgs;};};
      };
    };
}
