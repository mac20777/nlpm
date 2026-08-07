---
name: init
description: Initialize NLPM state for a project, choose a score threshold, inventory artifacts, and capture a baseline. Use when adopting NLPM in a repository for the first time or intentionally reconfiguring it.
---

# Initialize NLPM

Use this workflow for `$nlpm-init [directory]`.

1. Read `../../references/workflows.md`, then resolve the target directory.
2. If `.nlpm/config.md` already exists, show its effective settings and ask
   whether to reconfigure unless the user already said to overwrite it. Never
   replace an existing config silently.
3. Inventory artifacts with the `$nlpm-ls` procedure.
4. Obtain strictness from the user's request. If unspecified and interactive
   input is available, ask for relaxed (60), standard (70), or strict (80).
   Otherwise use standard and say so.
5. Create `.nlpm/config.md` with YAML frontmatter containing `strictness` and
   `score_threshold`, followed by a short human-readable explanation.
6. Add `.nlpm/history.json` and `.nlpm/reports/` to `.gitignore` only when the
   exact lines are absent. Preserve all unrelated ignore rules.
7. If artifacts exist, run the `$nlpm-score` procedure over the full target and
   save the baseline snapshot. Scoring failure is a warning; it must not undo a
   successfully written config.

Report the strictness, threshold, artifact count, config path, and baseline
score when available. Do not create `.claude/` state. Existing legacy NLPM
state remains readable through the compatibility rules but is not overwritten.
