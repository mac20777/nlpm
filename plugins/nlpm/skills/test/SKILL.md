---
name: test
description: Evaluate natural-language programming artifacts against .nlpm-test specification files. Use for NL-TDD, trigger-behavior tests, output-contract checks, and minimum-score gates for skills, agents, commands, rules, hooks, or prompts.
---

# Test NL artifacts from specs

Use this workflow for `$nlpm-test [spec-file|directory]`.

1. Read `../../references/workflows.md`, `../testing/SKILL.md`, and
   `../scoring/SKILL.md`.
2. Discover `.nlpm-test/*.spec.md`, all `*.spec.md` in a requested directory,
   or the requested single spec. If none exist, explain where to create them
   and point to the bundled testing reference.
3. Load the effective NLPM score threshold. For every spec, parse its
   frontmatter and validate `artifact`, artifact type, and optional
   `min_score`. A missing artifact is `RED`, the expected TDD starting state,
   rather than an infrastructure failure.
4. Read each existing artifact and evaluate every section present in its spec:
   frontmatter expectations, positive triggers, negative triggers, required
   output content and format, handled inputs, rule examples, and minimum score.
   Trigger predictions are semantic heuristics; report YES/NO and confidence.
5. When collaboration tools are available, analyze independent batches of up
   to three specs using read-only subagents. Aggregate in the main thread.

Return one row per spec with artifact, `PASS|FAIL|RED`, score, and check count.
For failures, name the exact expectation, actual evidence, and smallest useful
fix. Finish with passed, failed, and red totals; when all existing artifacts
pass, end with `All specs pass. GREEN.`

Never modify artifacts or specs during this skill. Testing is read-only.
