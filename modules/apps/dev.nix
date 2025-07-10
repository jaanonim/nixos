{
  pkgs,
  jaanonim-pkgs,
  ...
}: {
  my._packages = with pkgs;
    [
      # jetbrains.clion
      jetbrains.pycharm-professional
      # jetbrains.idea-ultimate
      # jetbrains.goland
      vscode
    ]
    ++ (with jaanonim-pkgs; [creator forklab]);
}
