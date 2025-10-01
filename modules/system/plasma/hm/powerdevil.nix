_: {
  programs.plasma = {
    kscreenlocker = {
      autoLock = false;
      timeout = 15;
    };
    powerdevil = {
      AC = {
        powerButtonAction = "shutDown";
        autoSuspend.action = "nothing";
        whenLaptopLidClosed = "doNothing";
        displayBrightness = 75;
        powerProfile = "balanced";
        inhibitLidActionWhenExternalMonitorConnected = false;
        turnOffDisplay = {
          idleTimeout = 3600;
          idleTimeoutWhenLocked = 600;
        };
        dimDisplay.enable = false;
      };
      battery = {
        powerButtonAction = "shutDown";
        displayBrightness = 50;
        powerProfile = "powerSaving";
        autoSuspend = {
          action = "sleep";
          idleTimeout = 1800;
        };
        whenLaptopLidClosed = "sleep";
        turnOffDisplay = {
          idleTimeout = 900;
          idleTimeoutWhenLocked = 300;
        };
        dimDisplay = {
          enable = true;
          idleTimeout = 600;
        };
      };
      lowBattery = {
        powerButtonAction = "shutDown";
        displayBrightness = 20;
        powerProfile = "powerSaving";
        autoSuspend = {
          action = "hibernate";
          idleTimeout = 900;
        };
        whenLaptopLidClosed = "sleep";
        turnOffDisplay = {
          idleTimeout = 600;
          idleTimeoutWhenLocked = 300;
        };
        dimDisplay = {
          enable = true;
          idleTimeout = 180;
        };
      };
    };
  };
}
