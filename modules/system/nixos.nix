{
  lib,
  config,
  ...
}:
with lib; let
  my = config.my;
  cfg = config.my.nix;
  allowedUsers = [
    "root"
    my.mainUser
  ];

  intervals = {
    daily = "5d";
    weekly = "7d";
    monthly = "30d";
  };
  datesType = types.enum (builtins.attrNames intervals);
in {
  options.my.nix = {
    gc = mkOption {
      type = types.bool;
      default = true;
      description = "Enable automatic nix gc";
    };
    optimize = mkOption {
      type = types.bool;
      default = true;
      description = "Enable automatic nix store optimize";
    };
    extraAllowedUsers = mkOption {
      type = types.listOf types.str;
      default = [];
      example = ["@wheel" "admin"];
      description = "Add allowed and trusted users to list by default containing main user and root";
    };
    gcDates = mkOption {
      type = datesType;
      default = "weekly";
      description = "GC frequency (also sets `--delete-older-than` flag)";
    };
    optimiseDates = mkOption {
      type = datesType;
      default = "weekly";
      description = "Optimize frequency";
    };
    libraries = mkOption {
      type = types.listOf types.package;
      default = [];
      example = [pkgs.hello];
      description = "Extra libraries to be linked globally";
    };
    allowUnfree = mkOption {
      type = types.bool;
      default = true;
      example = false;
      description = "Allow unfree pkgs";
    };
    cuda = mkOption {
      type = types.bool;
      default = true;
      example = false;
      description = "Enable cuda support in nixpkgs";
    };
  };

  config = {
    environment.etc."nix/inputs/nixpkgs".source = "${nixpkgs}";
    nix = {
      warn-dirty = false;
      channel.enable = false; # use flakes
      registry.nixpkgs.flake = nixpkgs;

      settings = {
        experimental-features = ["nix-command" "flakes"];
        nix-path = lib.mkForce "nixpkgs=${inputs.nixpkgs}";
        download-buffer-size = 524288000; # 500 MB

        allowed-users = allowedUsers ++ cfg.extraAllowedUsers;
        trusted-users = allowedUsers ++ cfg.extraAllowedUsers;
      };

      optimise = mkIf cfg.optimise {
        automatic = true;
        dates = cfg.optimiseDates;
      };

      gc = mkIf cfg.gc {
        automatic = true;
        dates = cfg.gcDates;
        options = "--delete-older-than ${intervals.${cfg.gcDates}}";
      };

      programs.nix-ld = mkIf (builtins.length cfg.libraries != 0) {
        programs.nix-ld.enable = true;
        programs.nix-ld.libraries = cfg.libraries;
      };
    };

    nixpkgs = {
      config =
        mkIf cfg.allowUnfree {
          allowUnfree = true;
          allowUnfreePredicate = _: true;
        }
        // mkIf cfg.cuda {
          cudaSupport = true;
        };
    };
  };
}
