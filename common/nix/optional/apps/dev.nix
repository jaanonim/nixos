{
  pkgs,
  jaanonim-pkgs,
  ...
}: {
  packages = with pkgs;
    [
      # jetbrains.clion
      jetbrains.pycharm-professional
      jetbrains.idea-ultimate
      vscode
      libsForQt5.umbrello
    ]
    ++ (with jaanonim-pkgs; [creator forklab rider]);
}
