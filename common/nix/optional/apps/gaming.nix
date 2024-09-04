{
  pkgs,
  jaanonim-pkgs,
  ...
}: {
  packages = with pkgs;
    [
      steam
      (lutris.override {extraLibraries = pkgs: [pkgs.libunwind];})
    ]
    ++ (with jaanonim-pkgs; [pollymc]);
}
