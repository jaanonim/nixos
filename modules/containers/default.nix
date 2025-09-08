{
  lib,
  config,
  ...
}:
with lib; let
  inherit (config) my;
in {
  imports = builtins.map (path: ./. + /${path}) (builtins.attrNames (builtins.removeAttrs (builtins.readDir ./.) ["default.nix"]));

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
