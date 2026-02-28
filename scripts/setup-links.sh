#!/bin/bash
# agent_skills を Codex / Cursor / Claude にシンボリックリンクで配布するスクリプト

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AGENT_SKILLS="$(cd "$SCRIPT_DIR/.." && pwd)"

echo "agent_skills: $AGENT_SKILLS"

# Codex
if command -v codex &>/dev/null || [ -d ~/.codex ]; then
  echo "Setting up Codex links..."
  mkdir -p ~/.codex/skills/.system
  ln -sf "$AGENT_SKILLS/skill-creator" ~/.codex/skills/.system/skill-creator
  ln -sf "$AGENT_SKILLS/skill-installer" ~/.codex/skills/.system/skill-installer
  echo "  Done: ~/.codex/skills/.system/"
fi

# Cursor
echo "Setting up Cursor links..."
mkdir -p ~/.cursor/skills-cursor
for skill in create-rule create-skill create-subagent migrate-to-skills update-cursor-settings; do
  ln -sf "$AGENT_SKILLS/$skill" ~/.cursor/skills-cursor/$skill
done
echo "  Done: ~/.cursor/skills-cursor/"

# Claude
echo "Setting up Claude links..."
mkdir -p ~/.claude/skills
for skill in analyze-codebase debug-investigate; do
  ln -sf "$AGENT_SKILLS/$skill" ~/.claude/skills/$skill
done
echo "  Done: ~/.claude/skills/"

echo ""
echo "Setup complete!"
