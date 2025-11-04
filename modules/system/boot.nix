{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.my.boot;
in {
  options = {
    my = {
      boot = {
        optimize = mkOption {
          type = types.bool;
          default = true;
          example = false;
          description = "Optimize for faster boot time";
        };
        bootloaderTimeout = mkOption {
          type = types.int;
          default = 3;
          example = 1;
          description = "Grub system picker timeout";
        };
        grubConfigurationLimit = mkOption {
          type = types.int;
          default = 16;
          description = "Grub max configuration count";
        };
        quietBoot = mkOption {
          type = types.bool;
          default = false;
          description = "Disable printing kernel logs on boot";
        };
        secureBoot = mkOption {
          type = types.bool;
          default = false;
          description = "Enable Secure Boot support";
        };
      };
    };
  };

  config = {
    boot = {
      loader = {
        timeout = cfg.bootloaderTimeout;
        systemd-boot.enable = false;
        efi.canTouchEfiVariables = true;
        grub = {
          efiSupport = true;
          device = "nodev";
          configurationLimit = cfg.grubConfigurationLimit;
        };
      };
      lanzaboote = mkIf cfg.secureBoot {
        enable = true;
        pkiBundle = "/var/lib/sbctl";
      };

      kernelParams =
        if cfg.quietBoot
        then ["quiet"]
        else [];
    };

    services.journald = mkIf cfg.optimize {extraConfig = "SystemMaxUse=512M";};
    systemd.settings.Manager = mkIf cfg.optimize {DefaultTimeoutStopSec = "16s";};
  };
}
