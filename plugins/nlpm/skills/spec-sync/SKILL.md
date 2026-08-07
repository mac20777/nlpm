---
name: spec-sync
description: Research current first-party Claude Code, Codex, or Antigravity specifications and synchronize NLPM convention overlays with verified changes. Use when platform APIs, hooks, manifests, skill schemas, or tool conventions may have drifted.
---

# Synchronize convention overlays

Use this workflow for `$nlpm-spec-sync [claude|codex|antigravity|all]` from an
NLPM source checkout. This skill may edit overlays, but never commits, pushes,
publishes a marketplace entry, or bumps release manifests.

1. Read `../../references/workflows.md`. Map the requested tool to
   `codex/skills/conventions-<tool>/SKILL.md`; default to all three. Confirm each
   file exists.
2. Read each overlay completely and extract its authoritative first-party URLs,
   concrete schema claims, version/date snapshot, and stated uncertainties.
3. Browse only official vendor documentation and vendor-owned repositories.
   Fetch the current docs index and relevant changelog/releases. When
   collaboration tools are available, delegate one read-only research task per
   tool in parallel.
4. Classify evidence as `FIX`, `REMOVE`, `ADD`, `CONFIRM`, or `RESOLVED`.
   Separate structural facts directly named in current docs from approximate
   version attribution and facts not found. Cite a direct source for every
   correction.
5. Present the diagnosis before editing. Apply verified structural FIX,
   REMOVE, RESOLVED, and ADD items. Defer approximate tags, unavailable pages,
   conflicts between first-party sources, and unverified absence. Antigravity
   remains advisory where its specification is unsettled.
6. Preserve brief dated correction notes where they prevent regression. Update
   overlay-local version metadata only when that overlay already uses it:
   patch for corrections, minor for new sections.
7. Search fixed strings for old values throughout live NLPM artifacts and apply
   only unambiguous self-consistency repairs. Do not alter historical analysis,
   case studies, or intentional corrective examples.
8. Resolve the installed plugin root two directory levels above this skill's
   directory. Run `<plugin-root>/bin/nlpm-check .`, validate every changed
   skill, and confirm no stale live occurrence remains. Report exact failures.

Return per-overlay old/new versions, applied and deferred counts, citations,
self-consistency edits, verification status, and remaining release steps. If no
drift is verified, make no edits and say the overlays are current.
