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
    ]
    ++ (with jaanonim-pkgs; [creator forklab]);
}
