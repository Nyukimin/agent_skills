# agent_skills

Claude / Cursor で使えるエージェント用スキル集です。

## 含まれるスキル

| スキル | 説明 |
|--------|------|
| **analyze-codebase** | ソースコードを階層的に解析しドキュメント化する（Hierarchical Summarization） |
| **debug-investigate** | バグ症状から仮説駆動で原因を追跡する。analyze-codebase の出力があれば活用 |

## 使い方

### Cursor / Claude（プロジェクトで使う）

1. このリポジトリを clone する
2. プロジェクトの `.claude/skills/` または `.cursor/skills/` に、スキルをコピーするかシンボリックリンクを張る

```bash
# 例: JTAG プロジェクトで使う場合
cd /path/to/your/project
git clone https://github.com/Nyukimin/agent_skills.git /tmp/agent_skills
ln -s /tmp/agent_skills/analyze-codebase .claude/skills/analyze-codebase
ln -s /tmp/agent_skills/debug-investigate .claude/skills/debug-investigate
```

### 個人用（全プロジェクトで使う）

`~/.cursor/skills/` に上記と同様にコピーまたはシンボリックリンクを配置すると、どのプロジェクトでも利用できます。

## ライセンス

MIT など、利用したいライセンスをここに記載してください。
