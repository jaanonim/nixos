{
  pkgs,
  jaanonim-pkgs,
  ...
}: {
  packages = with pkgs;
    [
      # jetbrains.clion
      # jetbrains.pycharm-professional
      jetbrains.idea-ultimate
      android-studio
      vscode
      unityhub
    ]
    ++ (with jaanonim-pkgs; [creator forklab]);
}
