{
  config,
  lib,
  ...
}:
with lib; let
  inherit (config) my;
in {
  config = mkIf (builtins.any (ele: (ele == (lib.removeSuffix ".nix" (baseNameOf __curPos.file)))) my.apps) {
    home-manager.users.${my.mainUser} = mkIf my.homeManager {
      imports = [
        ../external/wakatime.nix
      ];

      sops.secrets."wakatime-api" = mkIf my.sops {};

      programs.wakatime = {
        enable = true;
        settings = {
          settings = {
            status_bar_coding_activity = false;
            status_bar_enabled = false;
            api_key_vault_cmd =
              if my.sops
              then "cat ${config.home-manager.users.${my.mainUser}.sops.secrets.wakatime-api.path}"
              else null;
          };
        };
      };
    };
  };
}
