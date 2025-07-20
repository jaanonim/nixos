{
  lib,
  config,
  ...
}:
with lib; {
  imports = builtins.map (path: ./. + /${path}) (builtins.attrNames (builtins.removeAttrs (builtins.readDir ./.) ["default.nix"]));

  options.my.containers = {
    domain = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "server.local";
      description = "Domain name for this host";
    };
    _domain = mkOption {
      type = types.str;
      description = "Internal don't change";
    };
  };

  config = {
    my.containers._domain =
      if domain == null
      then "${config.my.hostname}.local"
      else domain;
  };
}
