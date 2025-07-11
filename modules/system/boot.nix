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
          description = "Optimize for faster boot time";
        };
        bootloaderTimeout = mkOption {
          type = types.int;
          default = 1;
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
      };
    };
  };

  config =
    {
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
      };
    }
    // mkIf cfg.optimize {
      services.journald.extraConfig = "SystemMaxUse=512M";
      systemd.extraConfig = "DefaultTimeoutStopSec=16s";
    }
    // mkIf cfg.quietBoot {
      boot.kernelParams = ["quiet"];
    };
}
