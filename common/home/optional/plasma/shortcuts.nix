_: {
  programs.plasma = {
    shortcuts = {
      "services/org.kde.plasma-systemmonitor.desktop" = {
        "_launch" = "Ctrl+Shift+Esc";
      };
      "com.tomjwatson.Emote.desktop" = {
        "_launch" = "Meta+;";
      };
      "com.github.dynobo.normcap.desktop" = {
        "_launch" = "Meta+Shift+T";
      };
      kwin = {
        "Overview" = "Meta+Tab";
        "Switch One Desktop to the Left" = "Meta+Ctrl+Left";
        "Switch One Desktop to the Right" = "Meta+Ctrl+Right";
      };
    };

    spectacle.shortcuts = {
      captureRectangularRegion = "Meta+Shift+S";
    };
  };
}
