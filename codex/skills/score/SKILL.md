---
name: score
description: Score one or more natural-language programming artifacts on NLPM's 100-point rubric. Use for quality audits of skills, AGENTS.md, agents, commands, hooks, plugin manifests, and related AI configuration, including changed-only reviews.
---

# Score NL artifacts

Use this workflow for `$nlpm-score [path|--changed]`.

## Prepare

1. Read `../../references/workflows.md`.
2. Read `../rules/SKILL.md`, `../scoring/SKILL.md`, and
   `../conventions/SKILL.md`. Read only the platform overlays required by the
   discovered paths.
3. Load `.nlpm/config.md`, falling back to `.claude/nlpm.local.md`. Use the
   defaults from the shared reference on missing or malformed config.

Interpret input as follows:

- Empty input: score all discovered artifacts under the working directory.
- Directory: score all discovered artifacts below it.
- File: score that one artifact after classifying it.
- `--changed`: use `git diff --name-only HEAD` plus untracked files, then keep
  only NL artifacts. If the target is not a Git repository, report that
  `--changed` is unavailable.

If no artifacts remain, return `No NL programming artifacts found.`

## Analyze

Resolve the installed NLPM plugin root two directory levels above this skill's
directory. First run its bundled deterministic checker at
`<plugin-root>/bin/nlpm-check <target> --json`. Treat its
high-confidence findings as authoritative inputs, not duplicate penalties.

Score each file from 100 using the exact penalty table for its type. Every
deduction must include a rule id, severity, line or field, evidence, penalty,
and actionable fix. Respect documented intentional omissions. Do not score a
tool-specific artifact against another tool's schema.

Count vague quantifiers mechanically using the list in the conventions
reference. Mechanical counts override heuristic counts. Label judgment-based
checks, including trigger quality and ambiguity, as heuristic.

When collaboration tools are available, delegate independent batches of up to
five files as described in the shared reference. Aggregate and de-duplicate
findings in the main thread. Cap each file at 0; never award bonus points.

## Persist and report

Append a best-effort snapshot to `.nlpm/history.json` using the shared history
schema. Do not fail the score report if history cannot be written.

```text
NLPM Score Report

File                              Platform  Type             Score  Findings
...

Overall: A/100 — EXCELLENT|GOOD|ADEQUATE|WEAK|REWRITE
Threshold: T · Below threshold: N
High: H · Medium: M · Low: L

Top findings:
1. [severity] path:line — evidence and fix (-P, rule)
```

Bands: 90+ Excellent, 80–89 Good, 70–79 Adequate, 60–69 Weak, below
60 Rewrite. Unreadable files are warnings. Empty files score 0. Malformed
frontmatter receives the documented penalty and the body is still reviewed.
