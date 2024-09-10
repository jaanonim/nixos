{
  lib,
  configLib,
  pkgs,
  ...
}: let
  mkPanel = screen: {
    location = "bottom";
    height = 40;
    floating = true;
    hiding = "none";
    inherit screen;

    widgets = [
      # We can configure the widgets by adding the name and config
      # attributes. For example to add the the kickoff widget and set the
      # icon to "nix-snowflake-white" use the below configuration. This will
      # add the "icon" key to the "General" group for the widget in
      # ~/.config/plasma-org.kde.plasma.desktop-appletsrc.
      {
        kickoff = {
          icon = "${configLib.get_util "profile-image" {inherit pkgs;}}/profile.png";
          showActionButtonCaptions = false;
        };
      }
      # Adding configuration to the widgets can also for example be used to
      # pin apps to the task-manager, which this example illustrates by
      # pinning dolphin and konsole to the task-manager by default.
      {
        name = "org.kde.plasma.icontasks";
        config = {
          General.launchers = [
            "applications:org.kde.dolphin.desktop"
            "applications:org.kde.konsole.desktop"
            "applications:brave-browser.desktop"
          ];
        };
      }
      # If no configuration is needed, specifying only the name of the
      # widget will add them with the default configuration.

      # If you need configuration for your widget, instead of specifying the
      # the keys and values directly using the config attribute as shown
      # above, plasma-manager also provides some higher-level interfaces for
      # configuring the widgets. See modules/widgets for supported widgets
      # and options for these widgets. The widgets below shows two examples
      # of usage, one where we add a digital clock, setting 12h time and
      # first day of the week to sunday and another adding a systray with
      # some modifications in which entries to show.
      {
        systemMonitor = {
          title = "Wykorzystanie pamieci/procesora";
          displayStyle = "org.kde.ksysguard.piechart";
          showTitle = false;
          showLegend = false;
          sensors = [
            {
              name = "cpu/all/usage";
              color = "0,176,245"; # "${lib.stylix.colors.base0D-rgb-r},${lib.stylix.colors.base0D-rgb-g},${lib.stylix.colors.base0D-rgb-b}";
              label = "Wykorzystanie";
            }
          ];
          totalSensors = ["memory/physical/used" "cpu/all/usage"];
          textOnlySensors = [];
        };
      }
      "org.kde.plasma.marginsseparator"
      {
        systemTray.items = {
          shown = [
            "org.kde.plasma.battery"
            "org.kde.plasma.networkmanagement"
            "org.kde.plasma.volume"
            "org.kde.kdeconnect"
            "discord"
          ];
          hidden = [
            "org.kde.plasma.bluetooth"
            "org.kde.plasma.nightcolorcontrol"
            "org.kde.plasma.clipboard"
            "org.kde.plasma.brightness"
            "aw-qt"
          ];
        };
      }
      {
        digitalClock = {
          calendar.firstDayOfWeek = "monday";
          calendar.plugins = ["pimevents"];
          time.format = "24h";
        };
      }
      "org.kde.plasma.showdesktop"
    ];
  };
in {
  programs.plasma.panels = lib.mkForce [
    # Windows-like panel at the bottom
    (mkPanel 0)
    (mkPanel 1)
  ];
}
