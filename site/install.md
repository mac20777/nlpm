---
title: How to install
outline: [2, 3]
---

# How to install

NLPM has three install surfaces — pick whichever fits your environment.

The **Claude Code plugin** exposes twelve `/nlpm:*` commands backed by
specialist agents. The **Codex plugin** exposes the same twelve user goals as
`$nlpm-*` workflow skills and includes the same reference catalog. Both use the
same cross-tool scoring rubric for **Claude Code, Codex, and Antigravity**.

The **standalone binary** (`bin/nlpm-check`) has no agent dependency. Use it in
any project's pre-commit hook or CI.

## Plugin install (Claude Code)

Two install paths — both reach the same code:

### Via Anthropic's official community marketplace

Curated; updates lag the maintainer marketplace by up to ~24h.

```bash
claude plugin marketplace add anthropics/claude-plugins-community
claude plugin install nlpm@claude-community --scope project   # or --scope user
```

### Via the xiaolai marketplace

Latest version lands here first.

```bash
claude plugin marketplace add xiaolai/claude-plugin-marketplace

# Project scope (recommended)
claude plugin install nlpm@xiaolai --scope project

# Global (all projects)
claude plugin install nlpm@xiaolai --scope user
```

> **"Plugin not found in marketplace 'xiaolai'"?** Your local marketplace clone is stale. Run `claude plugin marketplace update xiaolai` and retry — `plugin install` does not auto-refresh. (The community marketplace doesn't have this caveat.)

Then in your project:

```bash
/nlpm:ls              # discover NL artifacts
/nlpm:score           # 100-point quality scoring
/nlpm:check           # cross-component consistency
/nlpm:vocab-init      # bootstrap a vocabulary skill (optional)
/nlpm:report          # render a self-contained HTML report
```

## Plugin install (Codex)

```bash
codex plugin marketplace add xiaolai/nlpm --ref main
codex plugin add nlpm@xiaolai
```

To test a local checkout, pass the repository path instead of `xiaolai/nlpm`.
The marketplace installs the self-contained package at `plugins/nlpm/`. Then:

```text
$nlpm-ls
$nlpm-score
$nlpm-check
$nlpm-security-scan .
```

The bundled advisory hook is not trusted automatically. Review it with
`/hooks` before enabling it.

## Standalone binary (any CI, no agent required)

`bin/nlpm-check` is a single-file Python 3.11+ script (stdlib only) that runs the deterministic subset of `/nlpm:check`. It validates the universal floor (the agentskills.io open spec, AGENTS.md conventions, manifest-vs-disk consistency, vague-quantifier checks) regardless of which tool authored the artifacts. Drop into pre-commit hooks or CI.

```bash
git clone https://github.com/xiaolai/nlpm
./nlpm/bin/nlpm-check /path/to/your/plugin
```

Or copy `bin/nlpm-check` into your repo:

```bash
curl -fsSL https://raw.githubusercontent.com/xiaolai/nlpm/main/bin/nlpm-check -o nlpm-check
chmod +x nlpm-check
./nlpm-check .
```

Pre-commit hook and GitHub Actions workflow templates live at:

- `templates/pre-commit-nlpm.sh`
- `templates/workflows/nlpm-check.yml`

## Vocabulary discipline (R51, opt-in)

After installing NLPM in your project, decide whether to enforce a canonical noun/verb registry. If yes:

```bash
/nlpm:vocab-init or $nlpm-vocab-init
```

This writes `skills/<plugin>/vocabulary/SKILL.md` + `registry.yaml`. Prune the
seeded tables, define `deprecated:` synonym lists, then opt into R51 in
`.nlpm/config.md` for Codex or `.claude/nlpm.local.md` for Claude Code (Codex
can read the latter as a compatibility fallback):

```yaml
rule_overrides:
  R51:
    enabled: true
    vocabulary_skill: skills/<plugin>/vocabulary/
```

Now `/nlpm:score` and `/nlpm:check` flag deprecated-synonym occurrences. See [/reference/principles](/reference/principles) for the six principles behind R51.

## Updates

```bash
claude plugin update nlpm@xiaolai
```

## Uninstall

```bash
claude plugin uninstall nlpm@xiaolai
```

## See also

- [/reference/](/reference/) — full framework guide
- [Auditor dashboard](/dashboard.html) — cross-repo audit data
- [GitHub issues](https://github.com/xiaolai/nlpm/issues) — bug reports, feature requests
