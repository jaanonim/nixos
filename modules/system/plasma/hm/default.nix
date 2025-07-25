{
  inputs,
  lib,
  ...
}: {
  imports = [
    inputs.plasma-manager.homeManagerModules.plasma-manager
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

    desktop.mouseActions = {
      middleClick = "applicationLauncher";
      rightClick = "contextMenu";
    };

    configFile.kded5rc = {
      "Module-gtkconfig"."autoload" = false;
    };

    configFile.kdeglobals.General = {
      TerminalApplication = "ghostty";
      TerminalService = "com.mitchellh.ghostty.desktop";
    };
  };

  home.file.".config/fontconfig/conf.d/56-kubuntu-noto.conf".source = lib.root /config/56-kubuntu-noto.conf; # fix for font in plasma
}
