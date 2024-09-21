{
  pkgs,
  jaanonim-pkgs,
  ...
}: {
  packages = with pkgs;
    [
      # jetbrains.clion
      # jetbrains.pycharm-professional
      jetbrains.rider
      # android-studio
      vscode
      unityhub
    ]
    ++ (with jaanonim-pkgs; [creator]);
}
