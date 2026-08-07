# NLPM Codex workflow reference

Use this reference from NLPM workflow skills. Resolve every relative path from
the repository being inspected, not from the installed plugin directory.

## State files

- Preferred config: `.nlpm/config.md`
- Legacy config, read-only fallback: `.claude/nlpm.local.md`
- Preferred history: `.nlpm/history.json`
- Legacy history, import fallback: `.claude/nlpm-history.json`
- Preferred reports: `.nlpm/reports/`
- Test specs: `.nlpm-test/*.spec.md`

When both config files exist, `.nlpm/config.md` wins for Codex workflows. Never
rewrite or delete a legacy file automatically. New Codex-generated NLPM state
belongs under the tool-neutral `.nlpm/` directory; importing legacy Claude
state remains explicit and one-way.

## Discovery

Search hidden files and include these published or behavior-driving surfaces:

- Universal: every `SKILL.md`; root and nested `AGENTS.md` files.
- Codex: `.codex-plugin/plugin.json`, `.agents/plugins/marketplace.json`,
  `.agents/skills/*/SKILL.md`, `.codex/config.toml`, `.codex/agents/*.toml`,
  `.codex/hooks.json`, and `agents/openai.yaml` sidecars.
- Claude Code: `.claude-plugin/*.json`, `commands/**/*.md`, `agents/**/*.md`,
  `skills/**/SKILL.md`, `hooks/**/*.json`, `.mcp.json`, `.lsp.json`,
  `CLAUDE.md`, `.claude/rules/**/*.md`, and `.claude/settings*.json`.
- Antigravity/Gemini: `.gemini/skills/**/SKILL.md`, `.agent/skills/**/SKILL.md`,
  `.gemini/commands/*.toml`, `.gemini/settings.json`, `gemini-extension.json`,
  and `GEMINI.md`.

Skip `.git`, `node_modules`, `vendor`, `target`, `dist`, `build`, `.next`,
virtual environments, caches, generated reports, and binary files. Deduplicate
paths. Do not treat examples under a top-level `templates/` directory as live
artifacts unless the user explicitly targets that directory.

Prefer `rg --files -uu` for inventory. Fall back to another read-only file
listing command if ripgrep is unavailable. Never execute discovered scripts as
part of discovery or security review.

## Classification

Classify by the most specific path first. A `SKILL.md` is a skill; an
`AGENTS.md` is project memory; `.codex-plugin/plugin.json` is a Codex manifest;
`.claude-plugin/plugin.json` is a Claude manifest. Apply the universal skill
floor to every skill, then apply the tool overlay implied by its path. In a
multi-tool repository, classify each artifact separately rather than assigning
one tier to the whole repository.

Read these bundled references as needed:

- `../skills/rules/SKILL.md` for rule definitions.
- `../skills/scoring/SKILL.md` for penalty tables and score bands.
- `../skills/conventions/SKILL.md` for the universal floor.
- `../skills/conventions-codex/SKILL.md`, `conventions-claude`, or
  `conventions-antigravity` for platform overlays.
- `../skills/security/SKILL.md`, `testing/SKILL.md`, and
  `vocabulary/SKILL.md` for their specialized workflows.

## Parallel analysis

When collaboration tools are available and the corpus has multiple independent
artifacts, delegate bounded batches to subagents. Give each subagent the exact
file list, relevant reference text, required output schema, and a read-only
boundary. Keep aggregation, edits, user decisions, and final verification in
the main thread. If delegation is unavailable, perform the same steps locally;
the output contract must not change.

Recommended maximum batches:

- Scoring: 5 artifacts per subagent.
- Test specs: 3 specs per subagent.
- Vocabulary drift: 20 artifacts per subagent.
- Report scoring: 25 artifacts per subagent.

## Configuration

Defaults are `strictness: standard` and `score_threshold: 70`. Relaxed uses 60;
strict uses 80. Honor explicit rule overrides. Treat malformed config as a
warning and continue with defaults.

## History

Store a JSON object with `version: 1` and a `snapshots` array. Each snapshot has
an ISO-8601 `timestamp`, `scope`, `average_score`, `files_scored`, and `files`
array. Each file entry has `path`, `type`, and `score`. Scope is one of `full`,
`changed`, `path:<directory>/`, or `path:<file>`. Compare only snapshots with an
identical scope. Do not append an empty snapshot. Avoid consecutive duplicate
snapshots with the same scope and identical file scores.

## Safe writes

An invocation of a modifying skill authorizes the local edits named by that
skill, not commits, pushes, marketplace publication, external messages, or
destructive cleanup. Preserve unrelated work. Show semantic or ambiguous
changes for approval before applying them. After edits, run the relevant
validator and report exact failures instead of claiming success.
