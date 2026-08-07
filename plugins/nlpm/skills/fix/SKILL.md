---
name: fix
description: Apply safe mechanical fixes to NLPM findings and re-score the affected artifacts. Use when the user asks to repair frontmatter, heading, naming, whitespace, or other automatically fixable NL artifact issues.
---

# Fix NL artifacts

Use this workflow for `$nlpm-fix [path]`.

1. Read `../../references/workflows.md` and run the `$nlpm-score` procedure on
   the target before editing. Preserve unrelated user changes.
2. Classify findings into mechanical, suggested semantic, and human-judgment
   changes.

Mechanical changes authorized by this invocation include:

- Add missing `user-invocable: false` to non-user shared partials.
- Rename Claude command frontmatter `tools` to `allowed-tools`; never make that
  rename in agent frontmatter.
- Repair skipped heading levels and trailing whitespace.
- Add a missing skill `name` derived exactly from its parent directory.
- Add a missing command argument hint when its body consumes arguments.
- Add a factual shared-partial description derived from its filename and first
  heading.

Show a diff and request approval before semantic changes such as model choice,
generated trigger examples, large skill splits, or wording that chooses between
contradictory requirements. Never auto-fix vague intent, security policy,
scope boundaries, output contracts, or contradictions.

After applying mechanical fixes, re-run the deterministic checker and re-score
all changed artifacts. If a validation command fails, report the exact failure.

Return files changed, each fix with its line, old and new per-file scores,
remaining judgment-required findings, and the overall score delta. If nothing
is mechanically fixable, make no edits and say that the remaining items need
human judgment.
