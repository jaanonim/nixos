{
  config,
  lib,
  ...
}:
with lib; let
  inherit (config) my;
  cfg = my.containers.samba;
in {
  options.my.containers.samba = {
    enable = mkEnableOption "samba";
    setPassword = mkOption {
      type = types.bool;
      default = false;
      description = "Set samba password for main user from sops secret";
    };
    settings = mkOption {
      type = types.attrsOf (types.attrsOf types.str);
      default = {};
      description = "Samba settings";
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.setPassword -> my.sops;
        message = "sops need to be enabled to set password for samba";
      }
    ];

    services = {
      samba = {
        enable = true;
        openFirewall = true;
        settings =
          {
            global = {
              "workgroup" = "WORKGROUP";
              "server string" = my.hostname;
              "netbios name" = my.hostname;
              "security" = "user";
              "guest account" = "nobody";
              "map to guest" = "bad user";
            };
          }
          // cfg.settings;
      };

      samba-wsdd = {
        enable = true;
        openFirewall = true;
      };
    };

    users.extraGroups.smbusers.members = [my.mainUser];
  };
}
