---
name: report
description: Generate a self-contained local HTML NLPM quality report with current scores, history, findings, cross-artifact links, and optional vocabulary data. Use when the user wants a durable visual report rather than chat-only output.
---

# Render an HTML report

Use this workflow for `$nlpm-report [directory]`.

1. Read `../../references/workflows.md`. Resolve a directory target and set
   the output directory to `<target>/.nlpm/reports/`.
2. Load effective config and history using the compatibility rules. Missing
   history produces a report with a `no history` state; malformed history is a
   visible warning, not a fatal error.
3. Discover and freshly score artifacts with the `$nlpm-score` procedure, then
   run the `$nlpm-check` cross-artifact procedure. For more than 50 artifacts,
   use read-only batches of up to 25 when collaboration is available.
4. If a vocabulary registry is configured or discoverable, include its scopes,
   verbs, nouns, declared homonyms, and only evidence-backed verb-to-output
   edges. If the corpus has at least five artifacts, include advisory vocabulary
   drift results.
5. Build the JSON input expected by the bundled `bin/nlpm-report`. Create the
   temporary input with a uniquely named temporary directory; do not use a
   shared fixed `/tmp` filename. Resolve the installed plugin root two
   directory levels above this skill's directory, then invoke
   `<plugin-root>/bin/nlpm-report` with explicit `--data`, `--project`, and
   `--out` paths.
6. Do not open a browser unless the user asks. Do not start a server or fetch
   remote assets; the report must remain self-contained.

Report the project, score, passing count, threshold, history snapshot count,
finding counts, and clickable local `index.html` path. Also report the archived
timestamped path when the renderer creates one. On renderer failure, preserve
the generated data file for diagnosis and return the exact stderr.
