#!/bin/bash
# Rebuild the installable Codex plugin from the repository's Codex sources.
set -euo pipefail

repo_root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
plugin_root="$repo_root/plugins/nlpm"

if [ ! -f "$plugin_root/.codex-plugin/plugin.json" ]; then
  echo "error: missing $plugin_root/.codex-plugin/plugin.json" >&2
  exit 2
fi

mkdir -p \
  "$plugin_root/analysis/scripts" \
  "$plugin_root/agents" \
  "$plugin_root/bin" \
  "$plugin_root/hooks" \
  "$plugin_root/references" \
  "$plugin_root/scripts" \
  "$plugin_root/skills" \
  "$plugin_root/templates/report"

rsync -a --delete "$repo_root/codex/skills/" "$plugin_root/skills/"
rsync -a --delete "$repo_root/codex/references/" "$plugin_root/references/"
rsync -a --delete "$repo_root/templates/report/" "$plugin_root/templates/report/"

cp "$repo_root/bin/nlpm-check" "$plugin_root/bin/nlpm-check"
cp "$repo_root/bin/nlpm-report" "$plugin_root/bin/nlpm-report"
cp "$repo_root/bin/nlpm-build-docs" "$plugin_root/bin/nlpm-build-docs"
cp "$repo_root/analysis/scripts/extract-vocabulary.py" \
  "$plugin_root/analysis/scripts/extract-vocabulary.py"
cp "$repo_root/analysis/vocabulary-design-principles.md" \
  "$plugin_root/analysis/vocabulary-design-principles.md"
cp "$repo_root/agents/vocab-drift-scanner.md" \
  "$plugin_root/agents/vocab-drift-scanner.md"
cp "$repo_root/hooks/hooks.json" "$plugin_root/hooks/hooks.json"
cp "$repo_root/scripts/check-artifact.sh" \
  "$plugin_root/scripts/check-artifact.sh"
cp "$repo_root/codex/AGENTS.md" "$plugin_root/AGENTS.md"

chmod +x \
  "$plugin_root/bin/nlpm-check" \
  "$plugin_root/bin/nlpm-report" \
  "$plugin_root/bin/nlpm-build-docs" \
  "$plugin_root/analysis/scripts/extract-vocabulary.py" \
  "$plugin_root/scripts/check-artifact.sh"

echo "Built Codex plugin: $plugin_root"
