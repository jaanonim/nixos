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

        rules = ''
          # Environment
          - I am on NixOS.
          - Default shell is zsh unless otherwise noted.
          - Every project has its own shell.nix or flake devShell for project tools.

          # Tool availability
          - Do NOT assume any language runtime or project tool is in global PATH.
          - Check first: command -v <tool> 2>/dev/null
          - If missing, use the project shell — the permission system will prompt
            for approval before it runs.
          - For one-off tools: nix run nixpkgs#<pkg> -- <args>
            The permission system will prompt for approval.
          - NEVER attempt: nix-env, pip install, cargo install, npm install -g
            These are hard-denied by the permission system.

          # Available MCP tools
          You have the following MCP servers available. Use them proactively.

          ## pdf-reader
          Tools: read_pdf_metadata, read_pdf_text
          Use for: reading any local or remote PDF file.
          Workflow:
            1. read_pdf_metadata(path) — get page count, title, author
            2. read_pdf_text(path, pages: "1-5") — extract specific page range
            3. read_pdf_text(path) — extract full text for short docs (<30 pages)
          Paths: absolute (/home/user/docs/file.pdf) or relative to cwd (./docs/file.pdf)
          Also accepts URLs pointing directly to a PDF.

          ## nixpkgs-search
          Tools: search_nixos_options, search_nixpkgs_packages
          Use for: finding NixOS module options or nixpkgs package names without
          guessing. Prefer this over recalling package names from memory.
          The source must be one of "nixos, home-manager, darwin, flakes, flakehub, nixvim, wiki, nix-dev, noogle".

          ## context7
          Tools: resolve-library-id, get-library-docs
          Use for: fetching up-to-date documentation for any library or framework.
          Workflow:
            1. resolve-library-id(libraryName: "react") — get the library ID
            2. get-library-docs(libraryId: "...", topic: "hooks") — get relevant docs
          Use this before writing code that uses an unfamiliar or frequently-updated API.

          # PDF workflow
          - When asked to read or analyze a PDF, use the pdf-reader MCP tool.
          - Always call read_pdf_metadata first to get page count.
          - For docs > 30 pages, read ToC (pages 1-5) first, then targeted sections.
          - Cite page numbers in every factual claim.

          # General behavior
          - Keep changes minimal and focused. Do not refactor unless explicitly asked.
          - Show a diff summary before editing more than 2 files at once.
          - When uncertain about intent, ask rather than assume.
        '';
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
            enabled = true;
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
        };
      };
    };
  };
}
