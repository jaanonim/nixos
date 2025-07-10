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
}: let
  # evaluate our options
  eval = pkgs.lib.evalModules {
    modules = [
      ./modules/system/boot.nix
    ];
  };
  # generate our docs
  optionsDoc = pkgs.nixosOptionsDoc {
    inherit (eval) options;
  };
in
  # create a derivation for capturing the markdown output
  pkgs.runCommand "options-doc.md" {} ''
    cat ${optionsDoc.optionsCommonMark} >> $out
  ''
