{
  lib,
  config,
  ...
}:
with lib; let
  inherit (config) my;
in {
  imports = map (path: ./. + /${path}) (builtins.attrNames (removeAttrs (builtins.readDir ./.) ["default.nix"]));

  options.my.containers = {
    _hostDomain = mkOption {
      type = types.str;
      internal = true;
      description = "Real domain name used";
    };
  };

  config = {
    my.containers._hostDomain = "${my.hostname}.${my.infrastructure.domain}";
    virtualisation.oci-containers.backend =
      if my.docker.enable
      then "docker"
      else "podman";
  };
}
