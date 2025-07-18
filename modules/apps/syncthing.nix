{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  inherit (config) my;
in {
  config = mkIf (builtins.any (ele: (ele == (lib.removeSuffix ".nix" (baseNameOf __curPos.file)))) my.apps) {
    my._packages = with pkgs; [syncthing];

    services.syncthing = {
      enable = true;
      user = my.mainUser;
      dataDir = "/home/${my.mainUser}/Sync";
      configDir = "/home/${my.mainUser}/.config/syncthing";

      overrideDevices = true;
      overrideFolders = true;
      settings = {
        devices = {
          "s8" = {id = "WZ5YX2T-HXPRSEN-5MIJN5J-K6GWYJS-FVEAOUE-WLS7B3Y-DF5O2V3-HFOM3QY";};
        };
        folders = {
          "obsydian-jaanonim" = {
            path = "/mnt/dane/Obsydian/jaanonim/";
            devices = ["s8"];
            versioning = {
              type = "simple";
              params.keep = "30";
            };
          };
        };
      };
    };

    networking.firewall = {
      allowedTCPPorts = [8384 22000];
      allowedUDPPorts = [22000 21027];
    };
  };
}
