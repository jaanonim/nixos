# Environment

OS: NixOS | Shell: zsh | Each project provides its own env via `shell.nix` or `flake` devShell.

# Pre-Execution (MANDATORY)

Before any command: check for `shell.nix` / `flake.nix`, read them to identify tools and environment. Prefer tools defined there. Do not run project commands before this step.

# Tooling

- Never assume tools exist in PATH. Check: `command -v <tool> 2>/dev/null`
- Tool resolution: project devShell → `nix run nixpkgs#<pkg> -- <args>`
- **Forbidden:** `nix-env`, `pip install`, `cargo install`, `npm install -g`

# MCP Tools

At session start, inspect available MCP tools via `tools/list`. Use them according to the priority below — do not assume any tool exists before verifying. Tool descriptions define their own usage; do not rely on training data to infer behavior.

# Execution Rules

- Minimal, scoped changes only. No unsolicited refactoring. Ask when intent is ambiguous.

# Decision Priority

1. `shell.nix` / `flake.nix` — env + tool discovery
2. MCP doc tool (e.g. context7) — ALL docs & API usage; never guess APIs
3. MCP package search (e.g. nixpkgs-search) — package/option resolution
4. Project devShell — execution
5. `nix run` — fallback execution
6. Web search — **last resort only**

# Hard Failures

- Using web docs when an MCP doc tool applies
- Coding against guessed/unverified APIs
- Installing global tools
- Refactoring beyond task scope
