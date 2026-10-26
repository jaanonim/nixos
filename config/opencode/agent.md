# Environment

OS: NixOS | Shell: zsh | Each project provides its own env via `shell.nix` or `flake` devShell.

OpenCode will usually already be running inside the project's Nix shell. Use the inherited environment and run commands directly when the required tools are available.

# Environment Discovery

Read `shell.nix` / `flake.nix` only when needed to understand the project environment or resolve missing tools. Do not read them before every command or require reading them at session startup. Prefer tools provided by the project environment.

# Tooling

- Never assume tools exist in PATH. Check: `command -v <tool> 2>/dev/null`
- Tool resolution: current PATH → project devShell (if a required tool is missing) → `nix run nixpkgs#<pkg> -- <args>`
- Do not wrap every command in `nix-shell` or `nix develop`. Use a shell wrapper only when you are not already running in the project's Nix shell, or when a required tool or project environment is unavailable in the inherited environment.
- **Forbidden:** `nix-env`, `pip install`, `cargo install`, `npm install -g`

# MCP Tools

At session start, inspect available MCP tools via `tools/list`. Use them according to the priority below — do not assume any tool exists before verifying. Tool descriptions define their own usage; do not rely on training data to infer behavior.

# Execution Rules

- Follow KISS (Keep It Simple, Stupid): choose the simplest solution that meets the requirements. Avoid unnecessary complexity, abstractions, and overengineering.
- Minimal, scoped changes only. No unsolicited refactoring. Ask when intent is ambiguous.

# Decision Priority

1. Inherited environment — use available tools; consult `shell.nix` / `flake.nix` when needed
2. MCP doc tool (e.g. context7) — ALL docs & API usage; if Context7 is unavailable or fails, use web search to find official documentation instead; never guess APIs
3. MCP package search (e.g. nixpkgs-search) — package/option resolution
4. Inherited environment — direct execution; project devShell only when needed
5. `nix run` — fallback execution
6. Web search — fallback when Context7 is unavailable or fails; otherwise **last resort only**

# Hard Failures

- Using web docs when an applicable MCP doc tool is available and working
- Coding against guessed/unverified APIs
- Installing global tools
- Refactoring beyond task scope
