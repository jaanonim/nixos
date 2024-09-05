{
  configModules,
  config,
  ...
}: {
  imports = [
    configModules.home.wakatime
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
}
