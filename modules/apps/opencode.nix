{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  inherit (config) my;
  llama-swap-ip = "localhost"; # Hardcoded for now, could be made configurable if needed
in {
  config = mkIf (builtins.any (ele: (ele == (lib.removeSuffix ".nix" (baseNameOf __curPos.file)))) my.apps) {
    my._packages = with pkgs; [
      opencode
    ];

    home-manager.users.${my.mainUser} = mkIf my.homeManager {
      programs.opencode = {
        enable = true;
        enableMcpIntegration = true;

        settings = {
          autoshare = false;
          autoupdate = false;

          plugin = ["@alergeek-ventures/opencode" "opencode-wakatime"];

          permission = builtins.fromJSON (builtins.readFile (lib.root /config/opencode/permissions.json));

          provider = mkIf my.containers.llama.enable {
            llama-swap = {
              npm = "@ai-sdk/openai-compatible";
              name = "llama-swap";
              options = {
                baseURL = "http://${llama-swap-ip}:${toString my.containers.llama.port}/v1";
              };
              models =
                mapAttrs (modelName: modelCfg: {
                  name = modelName;
                  limit = {
                    inherit (modelCfg) context output;
                  };
                })
                my.containers.llama.models;
            };
          };
        };

        context = builtins.readFile (lib.root /config/opencode/agent.md);
      };

      programs.mcp = let
        nodeBin = "${pkgs.nodejs_22}/bin";
      in {
        enable = true;
        servers = {
          pdf-reader = {
            type = "stdio";
            command = "${nodeBin}/npx";
            args = ["-y" "@sylphx/pdf-reader-mcp"];
            enabled = false;
            env = {
              PATH = "${nodeBin}:/usr/bin:/bin";
            };
          };
          nixpkgs-search = {
            type = "stdio";
            command = "${pkgs.uv}/bin/uvx";
            args = ["mcp-nixos"];
            enabled = true;
          };
          context7 = {
            type = "stdio";
            command = "${nodeBin}/npx";
            args = ["-y" "@upstash/context7-mcp@latest"];
            enabled = true;
            env = {
              PATH = "${nodeBin}:/usr/bin:/bin";
            };
          };
          # will be fixed https://github.com/NixOS/nixpkgs/pull/525695
          playwright = {
            enabled = false;
            command = "${pkgs.playwright-mcp}/bin/playwright-mcp";
            args = ["--headless"];
          };
        };
      };
    };
  };
}
