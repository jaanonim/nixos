{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  inherit (config) my;
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
          model = "github-copilot/gpt-5-mini";

          plugin = ["@alergeek-ventures/opencode" "opencode-wakatime"];

          permission = {
            bash = {
              # Default: ask for approval on everything
              "*" = "ask";

              # Safe read-only commands — always allow
              "git status" = "allow";
              "git log *" = "allow";
              "git diff *" = "allow";
              "git diff" = "allow";
              "git show *" = "allow";
              "git branch *" = "allow";
              "git branch" = "allow";
              "cat *" = "allow";
              "ls *" = "allow";
              "ls" = "allow";
              "echo *" = "allow";
              "rg *" = "allow";
              "grep *" = "allow";
              "find *" = "allow";
              "fd *" = "allow";
              "jq *" = "allow";
              "command -v *" = "allow";
              "which *" = "allow";
              "type *" = "allow";
              "nix flake check *" = "allow";
              "nix flake check" = "allow";
              "nix build *" = "allow";
              "nix eval *" = "allow";

              # Ephemeral shells — ask (fall through to "*" = "ask", listed
              # explicitly here for clarity in the permission prompt)
              # nix-shell --run *   → "ask"
              # nix develop *       → "ask"
              # nix run *           → "ask"

              # Destructive git — ask explicitly (not auto-approved)
              # git commit *, git push *, git reset * → "ask"

              # Hard denies — imperative package installation, never allowed
              "nix-env *" = "deny";
              "nix-env --install *" = "deny";
              "cargo install *" = "deny";
              "npm install -g *" = "deny";
              "npm i -g *" = "deny";
              "yarn global add *" = "deny";
              "pnpm add -g *" = "deny";
              "gem install *" = "deny";
              "go install *" = "deny";
            };

            # File edits: ask by default, allow within project
            edit = {
              "*" = "ask";
            };

            # Reads are fine, but never read secrets
            read = {
              "*" = "allow";
              "*.env" = "deny";
              "*.envrc" = "deny";
              "*.env.*" = "deny";
              ".env.example" = "allow"; # example files are fine
            };

            # Web fetching: ask (agents should justify why they need external URLs)
            webfetch = "allow";
            websearch = "allow";
            codesearch = "allow";

            todoread = "allow";
            todowrite = "allow";

            # These default to "ask" already, but explicit is better
            doom_loop = "ask";
            external_directory = "ask";
          };
        };

        context = builtins.readFile (lib.root /config/opencode_agent.md);
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
