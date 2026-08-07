---
name: check
description: Check deterministic structure and cross-artifact consistency across Claude, Codex, or multi-tool NL programming repositories. Use to find broken references, unregistered files, orphans, contradictions, and terminology drift.
---

# Check an NL artifact system

Use this workflow for `$nlpm-check [path]`.

1. Read `../../references/workflows.md` and the conventions overlays matching
   the repository.
2. Resolve the target, discover all live artifacts, and read them. Report a
   missing path directly.
3. Resolve the installed plugin root two directory levels above this skill's
   directory, then run `<plugin-root>/bin/nlpm-check` against the target.
   Capture its exit code and full output. Exit 1 means
   structural findings, while exit 2 means the deterministic check could not
   run. Never hide either result.
4. If at least two artifacts exist, perform the judgment-based cross-artifact
   pass below. With fewer than two, report the deterministic result and explain
   that cross-artifact analysis needs multiple artifacts.

Check:

- References from commands, skills, agents, hooks, configs, and instruction
  files resolve to real in-repository targets.
- Manifest-declared component paths exist and live component files are
  registered or auto-discoverable for the relevant platform.
- Shared partials, scripts, and non-on-demand skills have a consumer.
- `always`/`never` requirements do not conflict across active instructions.
- Two artifacts do not claim the same exclusive responsibility.
- The same concept is not named inconsistently across artifacts.
- If R51 is enabled in config, deprecated terms in the declared vocabulary
  registry are reported with their canonical replacements.

Do not call a documented on-demand skill an orphan. Do not report templates as
live components. Quote both sides of any claimed contradiction.

Return:

```text
NLPM Cross-Artifact Check
Artifacts checked: N
Deterministic validator: clean | findings | unavailable
Reference integrity: R checked, B broken
Orphans: O
Contradictions: C
Terminology: T
Verdict: CLEAN | N findings
```

List exact paths and lines below each non-zero section.
