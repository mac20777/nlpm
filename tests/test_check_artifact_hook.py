"""Regression tests for the cross-client PostToolUse advisory hook."""

from __future__ import annotations

import json
import subprocess
import unittest
from pathlib import Path


REPO_ROOT = Path(__file__).resolve().parent.parent
HOOK = REPO_ROOT / "scripts" / "check-artifact.sh"


class TestCheckArtifactHook(unittest.TestCase):
    def run_hook(self, payload: dict) -> subprocess.CompletedProcess[str]:
        return subprocess.run(
            [str(HOOK)],
            input=json.dumps(payload),
            text=True,
            capture_output=True,
            check=False,
        )

    def test_codex_apply_patch_returns_additional_context(self) -> None:
        result = self.run_hook({
            "tool_name": "apply_patch",
            "hook_event_name": "PostToolUse",
            "tool_input": {
                "command": (
                    "*** Begin Patch\n"
                    "*** Update File: codex/skills/score/SKILL.md\n"
                    "*** Add File: AGENTS.md\n"
                    "*** End Patch"
                )
            },
        })
        self.assertEqual(result.returncode, 0)
        payload = json.loads(result.stdout)
        message = payload["hookSpecificOutput"]["additionalContext"]
        self.assertIn("SKILL.md", message)
        self.assertIn("AGENTS.md", message)
        self.assertIn("$nlpm-score", message)

    def test_codex_non_artifact_patch_is_silent(self) -> None:
        result = self.run_hook({
            "tool_name": "apply_patch",
            "hook_event_name": "PostToolUse",
            "tool_input": {
                "command": (
                    "*** Begin Patch\n"
                    "*** Update File: src/app.ts\n"
                    "*** End Patch"
                )
            },
        })
        self.assertEqual(result.returncode, 0)
        self.assertEqual(result.stdout, "")
        self.assertEqual(result.stderr, "")

    def test_claude_file_path_uses_slash_command_reminder(self) -> None:
        result = self.run_hook({
            "tool_name": "Edit",
            "tool_input": {"file_path": "/tmp/example/CLAUDE.md"},
        })
        self.assertEqual(result.returncode, 0)
        self.assertEqual(result.stdout, "")
        self.assertIn("/nlpm:score", result.stderr)


if __name__ == "__main__":
    unittest.main()
