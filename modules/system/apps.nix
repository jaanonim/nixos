{
  lib,
  config,
  ...
}:
with lib; let
  inherit (config) my;
in {
  options.my = {
    apps = mkOption {
      type = types.listOf types.str;
      default = ["git" "terminal" "tmux" "nix_dev"];
      example = [];
      description = "What apps packages to use";
    };
    extraUserPackages = mkOption {
      type = types.listOf types.package;
      default = [];
      description = "Main user extra packages";
    };
    _packages = mkOption {
      type = types.listOf types.package;
      default = [];
      description = "Internal don't touch :)";
    };
  };

  imports = builtins.map (path: ../apps + /${path}) (builtins.attrNames (builtins.readDir ../apps));

  config = {
    users.users.${my.mainUser}.packages = my._packages ++ my.extraUserPackages;
  };
}
