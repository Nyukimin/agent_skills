# agent_skills

Claude / Cursor / Codex で使えるエージェント用スキル集です。

## 含まれるスキル

### 汎用スキル

| スキル | 説明 |
|--------|------|
| **analyze-codebase** | ソースコードを階層的に解析しドキュメント化する（Hierarchical Summarization） |
| **debug-investigate** | バグ症状から仮説駆動で原因を追跡する。analyze-codebase の出力があれば活用 |

### Codex 用

| スキル | 説明 |
|--------|------|
| **skill-creator** | 効果的なスキルを作成・更新するガイド |
| **skill-installer** | キュレーションリストや GitHub からスキルをインストール |

### Cursor 用

| スキル | 説明 |
|--------|------|
| **create-rule** | Cursor ルール・AGENTS.md の作成 |
| **create-skill** | Cursor 用スキルの作成ガイド |
| **create-subagent** | サブエージェントの作成 |
| **migrate-to-skills** | 既存ルールをスキルへ移行 |
| **update-cursor-settings** | Cursor/VSCode の settings.json を編集 |

## 使い方

### クイックセットアップ（個人用）

このリポジトリを clone 後、セットアップスクリプトを実行：

```bash
git clone https://github.com/Nyukimin/agent_skills.git ~/agent_skills
cd ~/agent_skills
./scripts/setup-links.sh
```

### 手動セットアップ

#### Codex（`~/.codex/skills/.system/`）

```bash
AGENT_SKILLS=~/agent_skills  # または clone 先のパス

mkdir -p ~/.codex/skills/.system
ln -sf $AGENT_SKILLS/skill-creator ~/.codex/skills/.system/skill-creator
ln -sf $AGENT_SKILLS/skill-installer ~/.codex/skills/.system/skill-installer
```

#### Cursor（`~/.cursor/skills-cursor/`）

```bash
AGENT_SKILLS=~/agent_skills

mkdir -p ~/.cursor/skills-cursor
for skill in create-rule create-skill create-subagent migrate-to-skills update-cursor-settings; do
  ln -sf $AGENT_SKILLS/$skill ~/.cursor/skills-cursor/$skill
done
```

#### Claude（`~/.claude/skills/`）

```bash
AGENT_SKILLS=~/agent_skills

mkdir -p ~/.claude/skills
ln -sf $AGENT_SKILLS/analyze-codebase ~/.claude/skills/analyze-codebase
ln -sf $AGENT_SKILLS/debug-investigate ~/.claude/skills/debug-investigate
# 必要に応じて他のスキルも追加
```

### プロジェクト単位で使う

プロジェクトの `.claude/skills/` または `.cursor/skills/` にシンボリックリンクを配置：

```bash
cd /path/to/your/project
git clone https://github.com/Nyukimin/agent_skills.git /tmp/agent_skills
ln -s /tmp/agent_skills/analyze-codebase .claude/skills/analyze-codebase
ln -s /tmp/agent_skills/debug-investigate .claude/skills/debug-investigate
```

## ライセンス

MIT
