{
  config,
  lib,
  ...
}:
with lib; let
  my = config.my;
in {
  config = mkIf (builtins.any (ele: (ele == (lib.removeSuffix ".nix" (baseNameOf __curPos.file)))) my.apps) {
    home-manager.users.${my.mainUser} = mkIf my.homeManager {
      imports = [
        ../external/wakatime.nix
      ];

      programs.wakatime = {
        enable = true;
        settings = {
          settings = {
            status_bar_coding_activity = false;
            status_bar_enabled = false;
            api_key_vault_cmd = "cat ${config.sops.secrets.wakatime-api.path}";
          };
        };
      };
      sops.secrets."wakatime-api" = mkIf my.sops {};
    };
  };
}
