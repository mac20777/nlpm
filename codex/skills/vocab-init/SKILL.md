---
name: vocab-init
description: Bootstrap an evidence-based vocabulary skill and machine-readable registry from an NL artifact corpus. Use when a mature plugin or instruction-heavy repository wants to adopt NLPM R51 terminology discipline.
---

# Initialize a project vocabulary

Use this workflow for `$nlpm-vocab-init [directory]`.

1. Read `../../references/workflows.md` and `../vocabulary/SKILL.md`. Resolve
   the target directory and derive the plugin name from the Codex or Claude
   manifest, falling back to a normalized directory basename.
2. Detect scopes from live commands, agents, skills, Codex configuration,
   workflows, docs, and analysis notes. Require a meaningful NL surface; if
   only a few documentation files exist, explain that vocabulary enforcement is
   premature and make no changes.
3. Refuse to overwrite an existing vocabulary skill or registry.
4. Write `analysis/vocab-init-scopes.json` with the detected glob, scope, and
   grammatical role for each corpus source.
5. Resolve the installed plugin root two directory levels above this skill's
   directory, then run the bundled
   `<plugin-root>/analysis/scripts/extract-vocabulary.py` with explicit
   `--root`, `--scopes`, and `--out` arguments. Stop on a non-zero exit and
   report stderr. Do not invent extraction results.
6. From the generated verb and noun JSON, keep evidence-backed repeated terms:
   at most 15 verbs per scope with frequency at least 2, repeated role nouns,
   skill/domain nouns, and repeated single-word heading nouns.
7. Create `skills/<plugin>/vocabulary/SKILL.md` and adjacent `registry.yaml`.
   Mark the output as seeded and requiring human pruning. Include scopes,
   canonical terms, frequencies or evidence, empty deprecated-synonym lists,
   sanctioned cross-scope homonyms, and a rejected-pending-warrant section.
8. Keep R51 disabled. Add an opt-in snippet to the instructions using
   `.nlpm/config.md` and `rule_overrides.R51.vocabulary_skill`; do not silently
   enable a newly generated registry.

Report all generated paths, seeded term counts, and next steps: prune noise,
define at least several real synonym pairs, optionally run
`$nlpm-vocab-drift`, opt in to R51, then re-run score and check.
