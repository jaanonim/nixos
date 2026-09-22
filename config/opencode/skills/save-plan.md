---
name: save-plan
description: Use when asked to save or update an implementation plan for a feature, task, bugfix, or refactoring. Produces a structured markdown plan file that gives the next agent the highest chance of correct implementation.
---

# Save Plan

When the user says something like "save the plan", "write the plan to a file", "create an implementation plan", "update the plan", or any variation, use this skill to produce or edit a structured markdown plan.

## Directory & Naming

- Default plans directory: `.agents/plans/` (create it if it does not exist).
- If the project already has a different convention for plan files, use that instead.
- Filename format: `plan-{YYYY-MM-DD}-{slug}.md`
  - `{slug}`: a short kebab-case description of the task, e.g. `add-user-search`, `refactor-auth-flow`, `fix-race-condition-in-checkout`
- Example: `.agents/plans/plan-2024-01-15-add-user-search.md`
- If a plan with the same slug already exists for today, append a counter: `plan-2024-01-15-add-user-search-2.md`

## Frontmatter (YAML header)

Every plan file starts with:

```yaml
---
status: ready | in-progress | done
scope: feature | bugfix | refactor | spike | chore
---
```

- `status`: start with `ready` when first created; update to `in-progress` when implementation begins; set to `done` when fully implemented and verified.
- `scope`: choose the closest match to the nature of the work.

## Required Sections

Write these sections in order. Do not skip any.

### 1. Goal

One-paragraph description of what the plan aims to achieve. Include the "why" if it affects implementation choices (e.g. performance constraints, user-facing behavior, architectural precedent).

### 2. Files to Create / Modify

A flat list of every file that will be created, deleted, or materially changed. Use checkboxes (`- [ ]`) so the implementing agent can track progress.

Format:

```markdown
- [ ] `src/features/users/api/search.ts` — add query parameter handling to the list endpoint
- [ ] `src/features/users/components/UserList.tsx` — wire search input to the query
- [ ] `src/features/users/types.ts` — extend `UserListParams` with optional `search` field
```

Rules:

- Always include the full relative path from repo root.
- Add a short annotation explaining what must change in that file.
- List files in rough dependency order (files that others depend on first).
- If new directories must be created, list the directory with a note: `(create directory)`.

### 3. Implementation Steps

Numbered steps. Each step must be concrete enough that the next agent can execute it without asking for clarification.

Guidelines:

- One step per logical change (one commit-sized chunk).
- Include exact function names, module names, class names, route paths, component names, table names, or API endpoint paths when known.
- If a step involves adding a new API endpoint, database migration, or UI component, specify the signature / props / schema.
- Flag any step that requires running a generator, migration, build step, or server restart.
- If the change spans multiple layers (e.g. backend + frontend + database), group steps by layer and note the layer in the step title.

Example:

```markdown
1. **Backend: extend user list endpoint with search filter**
   - In `src/features/users/api/search.ts`, modify the list function to accept a `search` query parameter.
   - Apply a case-insensitive filter on `name` and `email` when `search` is present.

2. **Frontend: wire search input to the user list query**
   - In `src/features/users/components/UserList.tsx`, add a `<DebouncedInput>` bound to URL query param `?q=`.
   - Pass the value into the list query function so it refreshes when the input changes.

3. **Types: extend list params type**
   - In `src/features/users/types.ts`, add `search?: string` to `UserListParams`.
```

### 4. Code Snippets & API Signatures

Collect every existing API signature, type, schema, or interface that the implementing agent will need to reference. This prevents the next agent from guessing or re-discovering them.

Include:

- Existing database schema details (table names, column types, foreign keys, indexes) relevant to the change.
- Existing API endpoint signatures, request/response types, or GraphQL schemas.
- Existing component props, TypeScript interfaces, or class definitions that will be extended.
- Existing route definitions, URL patterns, or query params.
- Existing configuration keys or environment variables that must be read or added.

Format as a bullet list with inline code blocks. Only paste the relevant slices, not whole files.

Example:

````markdown
- Current `UserListParams` in `src/features/users/types.ts`:
  ```ts
  export interface UserListParams {
    limit?: number;
    offset?: number;
    sort?: "name" | "createdAt";
  }
  ```
````

- Current list endpoint in `src/features/users/api/search.ts`:
  ```ts
  export async function listUsers(params: UserListParams): Promise<User[]> {
    // ...
  }
  ```

````

### 5. Dependencies & Prerequisites

- External packages or libraries that must be installed (and the install command).
- Database migrations, code generation, or schema updates that must happen first.
- Environment variables, secrets, or config files that must be present.
- Other plans, PRs, or tickets that must merge or resolve first.
- Any architectural decisions already made that are not up for debate.
- Required access or permissions (e.g. API keys, service accounts).

If none apply, write `None.`

### 6. Open Questions / Risks

If anything is intentionally left undecided, or if there are known risks (performance, security, compatibility, ambiguity in requirements), list them here. Be explicit about what the implementing agent should not assume.

If nothing is open, write `None.`

### 7. Verification Checklist

How will the implementing agent (or reviewer) know the plan is complete? Use checkboxes.

Keep these generic but project-appropriate. Examples:

```markdown
- [ ] All quality checks / tests pass
- [ ] New or modified automated tests pass
- [ ] Manual verification confirms expected behavior
- [ ] Database migrations are generated and applied (if applicable)
- [ ] No new warnings or errors in build output
````

Adapt to the project's actual verification practices (e.g. if the project uses `make test`, `pytest`, `mix test`, `npm run test`, CI gates, lint checks, etc.).

## Editing an Existing Plan

If the user says "update the plan", "edit the plan", or references an existing plan file:

1. Read the existing plan file first.
2. Apply the requested changes, keeping the same structure and section order.
3. Update `status` in the frontmatter if appropriate (e.g. from `ready` → `in-progress` if implementation is starting).
4. Append a small "Changelog" section at the bottom if the edit is non-trivial:
   ```markdown
   ## Changelog

   - 2024-01-16: Added step 5 for bulk-update handling after review.
   - 2024-01-17: Clarified file path for search input component.
   ```

## Non-Negotiables

- **No vague steps.** "Implement the feature" or "Fix the bug" are unacceptable. Decompose into specific file + function / class / component changes.
- **No omitted file map.** The "Files to Create / Modify" section is mandatory. The next agent needs a map of the codebase before touching anything.
- **No large pasted files.** Keep snippets minimal and relevant. The goal is reference, not duplication.
- **No invented APIs.** If you are unsure of an existing signature, schema, or type, say so in "Open Questions / Risks" rather than guessing.
- **No project-specific assumptions in the skill itself.** The plan content should reflect the actual project's tech stack, but the skill structure works for any stack.
- **Always use checkboxes** for file lists and verification so progress is visually trackable.

## Workflow Summary

```
User: "Plan how to add user search, then save the plan"
→ Agent: (explores codebase, designs solution)
→ Agent: (writes plan file to .agents/plans/plan-{date}-{slug}.md)
→ User: (reviews plan, maybe asks to edit)
→ User: "Implement the plan in .agents/plans/plan-2024-01-15-add-user-search.md"
→ Next Agent: (reads plan file, implements step-by-step, checks boxes)
```
