{
  pkgs,
  jaanonim-pkgs,
  ...
}: {
  packages = with pkgs;
    [
      nix
      git
      nixpkgs-fmt
      alejandra
      nixd
      nil
      direnv
    ]
    ++ (with jaanonim-pkgs; [
      nsearch
    ]);
}
