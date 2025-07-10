{
  lib,
  config,
  ...
}:
with lib; let
  my = config.my;
  defaultApps = [
    "basic"
    "tools"
    "terminal"
    "media"
    "gaming"
    "discord"
    "obsidian"
    "gpu-screen-recorder"
    "syncthing"
    "activitywatch"
    "plasma"
    "dev"
    "nix_dev"
    # "unity_dev"
    # "android_dev"
    # "gns3"
    # "wireshark"
  ];
in {
  options.my = {
    apps = mkOption {
      type = types.listOf types.str;
      default = defaultApps;
      example = ["basic" "dev"];
      description = "What apps packages to use";
    };
    _packages = mkOption {
      type = types.listOf types.package;
      description = "Internal don't touch :)";
    };
  };

  imports = builtins.map (app: "../apps/${app}.nix") my.apps;
}
