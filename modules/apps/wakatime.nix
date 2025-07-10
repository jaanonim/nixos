{
  config,
  lib,
  ...
}:
with lib; let
  my = config.my;
in {
  imports = [
    ../external/wakatime.nix
  ];

  home-manager.users.${my.mainUser} = mkIf my.homeManager {
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
}
