{
  pkgs,
  jaanonim-pkgs,
  ...
}: {
  packages = with pkgs;
    [
      kdePackages.korganizer
      kdePackages.akonadi
      kdePackages.kdepim-addons
      kdePackages.kdepim-runtime
    ]
    ++ (with jaanonim-pkgs; [bible-runner]);
}
