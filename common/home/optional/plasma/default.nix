{inputs, ...}: {
  imports = [
    inputs.plasma-manager.homeManagerModules.plasma-manager
    ./konsole.nix
    ./panels.nix
    ./powerdevil.nix
    ./shortcuts.nix
  ];

  programs.plasma = {
    enable = true;

    workspace = {
      clickItemTo = "select";
      lookAndFeel = "org.kde.breezedark.desktop";
    };

    kwin = {
      titlebarButtons = {
        left = [];
        right = ["minimize" "maximize" "close"];
      };
    };

    desktop.mouseActions.middleClick = "applicationLauncher";
  };
}
