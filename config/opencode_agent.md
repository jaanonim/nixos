# 1. Environment

- OS: NixOS
- Default shell: `zsh` (unless explicitly overridden)
- Each project **MUST** provide its own environment via `shell.nix` or `flake` devShell

---

# 2. Pre-Execution Requirement (MANDATORY)

Before executing any command, the agent **MUST**:

1. Check for project environment files in the current directory:

- `shell.nix`
- `flake.nix`

2. If present, the agent **MUST** read them to:

- Identify available tools
- Understand the intended development environment

3. The agent **MUST** prefer using tools defined in these files over any external or inferred tooling

4. The agent **MUST NOT** run project-related commands before completing this step

---

# 3. Tooling Policy

## 3.1 Tool Availability

- The agent **MUST NOT** assume any tool exists in the global `PATH`
- The agent **MUST** check availability before use:

```sh
command -v <tool> 2>/dev/null
```

---

## 3.2 Tool Resolution Order

When a tool is required:

1. The agent **MUST** prefer the project devShell
2. If unavailable, the agent **MUST** use:

```sh
nix run nixpkgs#<pkg> -- <args>
```

- The agent **MUST NOT** bypass the permission system

---

## 3.3 Forbidden Actions

The agent **MUST NOT** execute:

- `nix-env`
- `pip install`
- `cargo install`
- `npm install -g`

These are hard-denied and considered violations.

---

# 4. MCP Tool Usage

## 4.1 context7 (Authoritative Documentation Source)

`context7` is the **PRIMARY and AUTHORITATIVE** source for documentation.

### Requirements

- The agent **MUST** use `context7` when:

- Referencing library/framework documentation
- Writing code using external APIs
- Working with evolving or version-sensitive tools

- The agent **MUST NOT**:

- Guess APIs from memory
- Rely on training data for documentation
- Use web search for docs if `context7` can provide them

- The agent **MUST** treat `context7` results as the source of truth

---

### Workflow (MANDATORY)

1. Resolve library:

```
resolve-library-id(libraryName: "<name>")
```

2. Fetch scoped docs:

```
get-library-docs(libraryId: "...", topic: "<topic>")
```

---

### Fallback Policy

- The agent **MAY** use web search **ONLY IF**:

- `context7` does not contain the library, OR
- Required information is missing after a targeted query

- This fallback **MUST be justified implicitly by failure**, not preference

---

## 4.2 nixpkgs-search

The agent **MUST** use this tool instead of guessing:

- Nix package names
- NixOS options
- Home Manager options

### Tools

- `search_nixos_options`
- `search_nixpkgs_packages`

### Sources

`nixos`, `home-manager`, `darwin`, `flakes`, `flakehub`, `nixvim`, `wiki`, `nix-dev`, `noogle`

---

## 4.3 pdf-reader

The agent **MUST** use `pdf-reader` for all PDF interactions.

### Workflow

1. Metadata:

```
read_pdf_metadata(path)
```

2. Content:

- If ≤30 pages:

  ```
  read_pdf_text(path)
  ```

- If >30 pages:

  ```
  read_pdf_text(path, pages: "1-5")
  ```

  Then targeted extraction

### Requirements

- The agent **MUST**:

- Start with metadata
- Cite page numbers for all factual claims

---

# 5. Execution Rules

- The agent **MUST** make minimal, scoped changes
- The agent **MUST NOT** refactor unless explicitly requested
- The agent **SHOULD** prefer project-local execution environments
- The agent **MUST** ask for clarification when intent is ambiguous

---

# 6. Decision Priority

The agent **MUST** follow this order:

1. Project environment (`shell.nix` / `flake.nix`)
2. `context7` → ALL documentation & API usage
3. `nixpkgs-search` → package and option resolution
4. Project devShell → tool execution
5. `nix run` → fallback execution
6. Web search → **LAST RESORT ONLY**

---

# 7. Violations (Hard Fail Conditions)

The following are considered **critical failures**:

- Skipping `shell.nix` / `flake.nix` inspection when present
- Using web documentation when `context7` was applicable
- Writing code against unverified or guessed APIs
- Installing global tools
- Ignoring project-provided environments
- Refactoring beyond task scope

---

# 8. Success Criteria

A compliant agent:

- Reads project environment definitions before acting
- Uses `context7` before writing non-trivial code
- Produces environment-reproducible commands
- Avoids global state mutation
- Minimizes changes to only what is required
