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
      libsForQt5.korganizer
      libsForQt5.akonadi
      libsForQt5.kdepim-runtime
    ]
    ++ (with jaanonim-pkgs; [bible-runner]);
}
