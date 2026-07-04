{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  llama-cpp =
    (pkgs.llama-cpp.override {
      cudaSupport = true;
      rocmSupport = false;
      metalSupport = false;
      blasSupport = true;
    }).overrideAttrs (oldAttrs: {
      cmakeFlags =
        (oldAttrs.cmakeFlags or [])
        ++ [
          "-DGGML_NATIVE=ON"
        ];
      preConfigure = ''
        export NIX_ENFORCE_NO_NATIVE=0
        ${oldAttrs.preConfigure or ""}
      '';
    });

  inherit (config) my;
  cfg = my.containers.llama;
in {
  imports = [./config.nix];

  options.my.containers.llama = {
    enable = mkEnableOption "llama server with llama-swap";

    models = mkOption {
      type = types.attrsOf (types.submodule {
        options = {
          hfId = mkOption {
            type = types.str;
            description = "Hugging Face model ID";
          };
          context = mkOption {
            type = types.int;
            description = "Context length";
            default = 8192;
          };
          output = mkOption {
            type = types.int;
            description = "Output length limit";
            default = 4096;
          };
          extraArgs = mkOption {
            type = types.listOf types.str;
            description = "Extra command line arguments for llama";
            default = [];
          };
        };
      });
      description = "Models to be used with llama-swap";
    };

    extraConfig = mkOption {
      type = types.str;
      description = "Extra configuration to be appended to llama-swap config.yaml";
      default = "";
    };

    extraConfigFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = "Path to extra configuration file to be included in llama-swap config.yaml";
    };

    port = mkOption {
      type = types.int;
      default = 9292;
      description = "Port for llama-swap to listen on";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [llama-cpp];

    systemd.services.llama-swap = {
      description = "llama-swap - OpenAI compatible proxy with automatic model swapping";
      after = ["network.target"];
      wantedBy = ["multi-user.target"];

      serviceConfig = {
        Type = "simple";
        User = "jaanonim";
        Group = "users";

        ExecStart = "${pkgs.llama-swap}/bin/llama-swap --config /etc/llama-swap/config.yaml --listen 0.0.0.0:${toString cfg.port} --watch-config";
        Restart = "always";
        RestartSec = 10;

        Environment = [
          "PATH=/run/current-system/sw/bin"
          "LD_LIBRARY_PATH=/run/opengl-driver/lib:/run/opengl-driver-32/lib"
        ];
      };
    };

    environment = {
      etc."llama-swap/config.yaml".text = ''
        models:
          ${builtins.concatStringsSep "\n  " (mapAttrsToList (modelName: modelCfg: ''
            ${modelName}:
                cmd: |
                  ${llama-cpp}/bin/llama-server
                  -hf ${modelCfg.hfId}
                  --port ''${PORT}
                  --ctx-size ${toString modelCfg.context}
                  ${builtins.concatStringsSep " " modelCfg.extraArgs}
          '')
          cfg.models)}
        ${cfg.extraConfig}
        ${optionalString (cfg.extraConfigFile != null) (builtins.readFile cfg.extraConfigFile)}
      '';
    };

    services.nginx.virtualHosts."llama.${my.containers._hostDomain}" = mkMerge [
      {
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString cfg.port}";
          proxyWebsockets = true;
          recommendedProxySettings = true;
        };
      }
      my.containers.nginx._extraConf
    ];
  };
}
