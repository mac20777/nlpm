#!/bin/bash
# PostToolUse hook: detect NL artifact edits and suggest the matching scorer.
# Fail-open (R31): any parse or classification failure exits successfully.
set +e

input=$(cat 2>/dev/null)
[ -n "$input" ] || exit 0

tool_name=""
hook_event=""
file_paths=""
patch_command=""

if command -v jq >/dev/null 2>&1; then
  tool_name=$(printf '%s' "$input" | jq -r '.tool_name // .toolName // empty' 2>/dev/null)
  hook_event=$(printf '%s' "$input" | jq -r '.hook_event_name // .hookEventName // empty' 2>/dev/null)
  file_paths=$(printf '%s' "$input" | jq -r '.tool_input.file_path // .toolInput.file_path // empty' 2>/dev/null)
  patch_command=$(printf '%s' "$input" | jq -r '.tool_input.command // empty' 2>/dev/null)
elif command -v python3 >/dev/null 2>&1; then
  parsed=$(printf '%s' "$input" | python3 -c '
import json, sys
try:
    data = json.load(sys.stdin)
    tool_input = data.get("tool_input") or data.get("toolInput") or {}
    print(data.get("tool_name") or data.get("toolName") or "")
    print(data.get("hook_event_name") or data.get("hookEventName") or "")
    print(tool_input.get("file_path") or "")
    print((tool_input.get("command") or "").replace("\n", "\\n"))
except Exception:
    pass
' 2>/dev/null)
  tool_name=$(printf '%s\n' "$parsed" | sed -n '1p')
  hook_event=$(printf '%s\n' "$parsed" | sed -n '2p')
  file_paths=$(printf '%s\n' "$parsed" | sed -n '3p')
  patch_command=$(printf '%s\n' "$parsed" | sed -n '4p' | sed 's/\\n/\
/g')
else
  file_paths=$(printf '%s' "$input" | grep -o '"file_path"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | sed 's/.*"file_path"[[:space:]]*:[[:space:]]*"//;s/"$//')
fi

# Codex apply_patch sends the whole patch as tool_input.command rather than a
# single file_path. Extract every path declared by the patch envelope.
if [ -n "$patch_command" ]; then
  patch_paths=$(printf '%s\n' "$patch_command" | sed -n \
    -e 's/^\*\*\* Add File: //p' \
    -e 's/^\*\*\* Update File: //p' \
    -e 's/^\*\*\* Delete File: //p')
  if [ -n "$patch_paths" ]; then
    if [ -n "$file_paths" ]; then
      file_paths=$(printf '%s\n%s' "$file_paths" "$patch_paths")
    else
      file_paths="$patch_paths"
    fi
  fi
fi

[ -n "$file_paths" ] || exit 0

is_artifact_path() {
  case "$1" in
    commands/*.md|*/commands/*.md) return 0 ;;
    agents/*.md|*/agents/*.md) return 0 ;;
    skills/*/SKILL.md|*/skills/*/SKILL.md) return 0 ;;
    .agents/skills/*/SKILL.md|*/.agents/skills/*/SKILL.md) return 0 ;;
    */.claude/rules/*.md|.claude/rules/*.md) return 0 ;;
    hooks/*.json|*/hooks/*.json|.codex/hooks.json|*/.codex/hooks.json) return 0 ;;
    .codex/config.toml|*/.codex/config.toml|.codex/agents/*.toml|*/.codex/agents/*.toml) return 0 ;;
    AGENTS.md|*/AGENTS.md|CLAUDE.md|*/CLAUDE.md|GEMINI.md|*/GEMINI.md) return 0 ;;
    .claude-plugin/plugin.json|*/.claude-plugin/plugin.json) return 0 ;;
    .codex-plugin/plugin.json|*/.codex-plugin/plugin.json) return 0 ;;
    .agents/plugins/marketplace.json|*/.agents/plugins/marketplace.json) return 0 ;;
    agents/openai.yaml|*/agents/openai.yaml) return 0 ;;
    .mcp.json|*/.mcp.json|.lsp.json|*/.lsp.json) return 0 ;;
    .gemini/settings.json|*/.gemini/settings.json|gemini-extension.json|*/gemini-extension.json) return 0 ;;
  esac
  return 1
}

artifact_names=""
while IFS= read -r file_path; do
  [ -n "$file_path" ] || continue
  if is_artifact_path "$file_path"; then
    name=$(basename "$file_path")
    case ",${artifact_names}," in
      *",${name},"*) ;;
      *)
        if [ -n "$artifact_names" ]; then
          artifact_names="${artifact_names}, ${name}"
        else
          artifact_names="$name"
        fi
        ;;
    esac
  fi
done <<EOF
$file_paths
EOF

[ -n "$artifact_names" ] || exit 0

if [ "$tool_name" = "apply_patch" ]; then
  message="NL artifact edited: ${artifact_names}. Run \$nlpm-score on the changed artifact before handoff."
  if command -v jq >/dev/null 2>&1; then
    jq -n --arg message "$message" '{hookSpecificOutput:{hookEventName:"PostToolUse",additionalContext:$message}}'
  elif command -v python3 >/dev/null 2>&1; then
    NLPM_HOOK_MESSAGE="$message" python3 -c '
import json, os
print(json.dumps({"hookSpecificOutput": {"hookEventName": "PostToolUse", "additionalContext": os.environ["NLPM_HOOK_MESSAGE"]}}))
' 2>/dev/null
  fi
else
  echo "NL artifact edited: ${artifact_names}. Run /nlpm:score on the changed artifact." >&2
fi

exit 0
