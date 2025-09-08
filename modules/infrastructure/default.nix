{lib, ...}:
with lib; {
  imports = [./configuration.nix];

  options.my.infrastructure = {
    domain = mkOption {
      type = types.str;
      default = "local";
      description = "Top level domain name for hosts. Domian for service will be constructed like`\${service}.\${hostname}.\${domain}`";
    };
    hosts = mkOption {
      type = types.attrsOf (
        types.submodule {
          options = {
            ip = mkOption {
              type = types.str;
              description = "Host IP";
            };
            description = lib.mkOption {
              type = types.str;
              default = "";
              description = "Host role description";
            };
          };
        }
      );
      default = {};
    };
  };
}
