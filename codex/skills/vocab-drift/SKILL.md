---
name: vocab-drift
description: Find likely vocabulary drift in an NL artifact corpus without requiring an enforced registry. Use for advisory synonym clustering before R51 adoption or as a periodic terminology-health review.
---

# Analyze vocabulary drift

Use this workflow for `$nlpm-vocab-drift [directory]`.

1. Read `../../references/workflows.md`, `../vocabulary/SKILL.md`, and discover
   project artifacts. Exclude private user memory files. Require at least five
   artifacts; smaller corpora do not support useful clustering.
2. Read an existing vocabulary registry when present and suppress sanctioned
   cross-scope homonyms.
3. Inventory repeated verb and noun candidates from filenames, frontmatter
   descriptions, headings, imperative body text, and local word neighborhoods.
   Ignore code syntax and stopwords. Record exact paths and lines.
4. Cluster only when both terms occur at least twice and evidence supports the
   same grammatical role. Use shared stems, morphological variants, bounded
   edit distance, or at least three shared context neighbors.
5. Judge each cluster as drift, likely drift, co-occurrence drift, distinct, or
   ambiguous. Suppress distinct concepts. Assign high confidence only when role
   and context overlap are both strong.
6. With collaboration tools, process independent batches of at most 20 files,
   then merge clusters sharing a term, combine evidence, retain the higher
   confidence, re-rank, and cap output at 20 candidates.

This workflow is advisory and applies no score penalty. For each emitted
cluster, report terms, frequencies, files affected, likely identity, evidence,
confidence, an existing corpus term as the suggested canonical, and the option
to declare a synonym or document a distinction. Never propose a new term as
canonical.

Finish by recommending `$nlpm-vocab-init` when no registry exists, or registry
updates for high-confidence pairs when one does.
