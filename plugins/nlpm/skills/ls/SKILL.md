---
name: ls
description: Discover and inventory natural-language programming artifacts in a repository. Use when the user asks what AI instructions, skills, agents, hooks, plugin manifests, or prompt configuration a project contains.
---

# Inventory NL artifacts

Use this workflow for `$nlpm-ls [directory]`.

1. Read `../../references/workflows.md`, especially Discovery and
   Classification.
2. Resolve the target to the requested directory or the current working
   directory. If it is missing, report `Directory not found: <path>`. If it is
   a file, tell the user to use `$nlpm-score` for a single artifact.
3. Inventory matching artifacts with a read-only search that includes hidden
   files. Apply all skip rules and deduplicate paths.
4. For every artifact, determine its platform, artifact type, line count, and
   approximate token count. Use `ceil(UTF-8 bytes / 4)` as the token estimate
   and label it as approximate.
5. Do not read secrets from unrelated environment files and do not execute any
   discovered code.

Return:

```text
NLPM Artifact Inventory

Plugin artifacts
Path                                      Platform      Type             Lines  Tokens~
...

Project configuration
Path                                      Platform      Type             Lines  Tokens~
...

Total: N artifacts · L lines · approximately T tokens
```

If nothing matches, return `No NL programming artifacts found in <path>.`
