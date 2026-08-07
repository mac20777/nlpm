# nlpm — full Codex workflow plugin

This tree is the source for NLPM's focused Codex workflow skills and shared
reference knowledge. The installable, self-contained plugin is assembled at
`plugins/nlpm/` by `scripts/build-codex-package.sh`. The Claude Code slash
commands remain under `commands/`; their Codex counterparts live here and
follow the same scoring rules.

## Workflow skills

| Skill | Goal |
|-------|------|
| `$nlpm-init` | Configure NLPM and capture a baseline |
| `$nlpm-ls` | Inventory NL artifacts across supported tools |
| `$nlpm-score` | Apply the 100-point rubric |
| `$nlpm-check` | Validate structure and cross-artifact consistency |
| `$nlpm-fix` | Apply safe mechanical fixes and re-score |
| `$nlpm-trend` | Compare matching historical snapshots |
| `$nlpm-test` | Run `.nlpm-test` NL-TDD specs |
| `$nlpm-security-scan` | Review executable plugin surfaces without running them |
| `$nlpm-report` | Render a self-contained local HTML report |
| `$nlpm-vocab-init` | Seed an evidence-based vocabulary registry |
| `$nlpm-vocab-drift` | Find advisory terminology drift |
| `$nlpm-spec-sync` | Refresh convention overlays from first-party specs |

Workflow skills share `codex/references/workflows.md`. Keep tool-neutral state
under `.nlpm/`; read legacy `.claude/nlpm*.json` or `.md` files only as a
compatibility fallback.

## Reference skills

The existing rules, scoring, conventions, security, testing, vocabulary,
patterns, orchestration, and writing skills remain loadable independently.
Workflow skills should reference them rather than duplicating penalty tables or
platform schemas.

## Development rules

- Keep every skill focused on one user goal with `name` and trigger-oriented
  `description` frontmatter only.
- Resolve supporting resources relative to the active `SKILL.md`.
- Use Codex subagents only for bounded read-only batches; keep aggregation,
  edits, and verification in the main thread.
- Preserve Claude Code compatibility. Do not change the Claude command contract
  merely to simplify a Codex workflow.
- Rebuild `plugins/nlpm/` after changing a Codex skill, shared reference,
  bundled runtime, hook, or report template.
- Run `python3 -m unittest tests.test_nlpm_check` and validate every changed
  skill before handing off changes.

Source and issue tracker: <https://github.com/xiaolai/nlpm>
