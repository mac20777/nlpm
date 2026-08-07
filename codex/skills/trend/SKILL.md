---
name: trend
description: Compare current NLPM quality scores with matching historical snapshots and record the new state. Use to track improvement, detect regressions, or establish a first score baseline for a repository or path.
---

# Show score trends

Use this workflow for `$nlpm-trend [path]`.

1. Read `../../references/workflows.md` and derive the invocation scope exactly
   as documented there.
2. Load `.nlpm/history.json`. If absent, import
   `.claude/nlpm-history.json` as a read-only baseline when present. Warn on
   malformed JSON and continue with empty history.
3. Run the `$nlpm-score` procedure for the requested scope. Ensure only one new
   snapshot is appended for this run.
4. Compare each current file with its most recent entry from a snapshot whose
   `scope` is identical. Label it improved, degraded, unchanged, or new. Never
   compare a path-scoped run with a full-repository snapshot.
5. Compare current and previous averages for that scope and show the sequence
   of matching snapshot averages. On a first run, label all files new and call
   the saved snapshot the baseline.

Return:

```text
NLPM Trend Report
Scope: <scope> · Snapshot: <timestamp>

File                              Score  Previous  Delta  State
...

Overall: A/100 (was B, +/-D)
Degraded: ...
Trend: X -> Y -> Z (improving|stable|degrading|mixed)
```

Do not infer a direction from a single snapshot. If history persistence fails,
still return the comparison and clearly state that the new snapshot was not
saved.
