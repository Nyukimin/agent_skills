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

### Apify スキル（[apify/agent-skills](https://github.com/apify/agent-skills)）

Web スクレイピング・データ抽出・自動化用。Apify アカウントと API トークンが必要。

| スキル | 説明 |
|--------|------|
| **apify-actor-development** | Apify Actor の開発・デバッグ・デプロイ |
| **apify-actorization** | 既存プロジェクトを Apify Actor に変換 |
| **apify-ultimate-scraper** | 汎用 AI スクレイパー（Instagram, Facebook, Google 等） |
| **apify-lead-generation** | B2B/B2C リード生成 |
| **apify-ecommerce** | eコマースデータ取得（価格調査等） |
| **apify-market-research** | 市場調査・分析 |
| その他 12 スキル | audience-analysis, brand-reputation-monitoring, competitor-intelligence 等 |

## 使い方

### クイックセットアップ（個人用）

このリポジトリを clone 後、セットアップスクリプトを実行（submodule 含む）：

```bash
git clone --recurse-submodules https://github.com/Nyukimin/agent_skills.git ~/agent_skills
cd ~/agent_skills
./scripts/setup-links.sh
```

既に clone 済みの場合は submodule を取得：

```bash
cd ~/agent_skills
git submodule update --init
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
# Apify skills（submodule 取得後）
for skill in $AGENT_SKILLS/apify-agent-skills/skills/*/; do
  ln -sf "$skill" ~/.cursor/skills-cursor/$(basename "$skill")
done
```

#### Claude（`~/.claude/skills/`）

```bash
AGENT_SKILLS=~/agent_skills

mkdir -p ~/.claude/skills
for skill in analyze-codebase debug-investigate create-rule create-skill skill-creator skill-installer; do
  ln -sf $AGENT_SKILLS/$skill ~/.claude/skills/$skill
done
# Apify skills（submodule 取得後）
for skill in $AGENT_SKILLS/apify-agent-skills/skills/*/; do
  ln -sf "$skill" ~/.claude/skills/$(basename "$skill")
done
```

### プロジェクト単位で使う

プロジェクトの `.claude/skills/` または `.cursor/skills/` にシンボリックリンクを配置：

```bash
cd /path/to/your/project
git clone https://github.com/Nyukimin/agent_skills.git /tmp/agent_skills
ln -s /tmp/agent_skills/analyze-codebase .claude/skills/analyze-codebase
ln -s /tmp/agent_skills/debug-investigate .claude/skills/debug-investigate
```

## Apify スキル利用時の前提条件

- [Apify アカウント](https://apify.com)
- API トークン（Apify Console で取得）
- `.env` に `APIFY_TOKEN=your_token` を設定

## ライセンス

MIT
