{
  pkgs ?
  # If pkgs is not defined, instantiate nixpkgs from locked commit
  let
    lock = (builtins.fromJSON (builtins.readFile ./flake.lock)).nodes.nixpkgs.locked;
    nixpkgs = fetchTarball {
      url = "https://github.com/nixos/nixpkgs/archive/${lock.rev}.tar.gz";
      sha256 = lock.narHash;
    };
  in
    import nixpkgs {overlays = [];},
  ...
}:
pkgs.mkShell {
  # NIX_BUILD_SHELL = "zsh";
  NIX_CONFIG = "extra-experimental-features = nix-command flakes";
  nativeBuildInputs = with pkgs; [
    just
    just-lsp
    nh
    deploy-rs
    nix-output-monitor
    nurl
    nix-tree
    nix-inspect
  ];
}
