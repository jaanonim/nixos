{
  pkgs,
  jaanonim-pkgs,
  ...
}: {
  packages = with pkgs;
    [
      # jetbrains.clion
      # jetbrains.pycharm-professional
      android-studio
      vscode
      unityhub
    ]
    ++ (with jaanonim-pkgs; [creator]);
}
