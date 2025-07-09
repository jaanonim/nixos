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

  home-manager.users.${my.mainUser}.programs.wakatime = mkIf my.homeManager {
    enable = true;
    settings = {
      settings = {
        status_bar_coding_activity = false;
        status_bar_enabled = false;
        api_key_vault_cmd = "cat ${config.sops.secrets.wakatime-api.path}";
      };
    };
  };
}
