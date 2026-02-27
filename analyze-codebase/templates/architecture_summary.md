# アーキテクチャ総合 テンプレート

Phase 1 の全成果物を統合し、システム全体のレポートを生成する。

**生成時に付与する frontmatter の例**:
```yaml
---
generated_at: "2025-02-27T15:00:00+09:00"
run_id: run_YYYYMMDD_HHMMSS
phase: 1
step: "9"
profile: {profile_name}
artifact: architecture_summary
---
```

**必須セクション**: templates/schema/architecture_summary_required_sections.yaml を参照。

---

## 概要

（システム全体を2〜3行で要約すること。）

---

## システムアーキテクチャ概要

（1ページ程度で全体像を記述する。）

---

## モジュール依存図

（完全なモジュール依存関係を図または表で記述する。）

---

## 主要データフロー

（主要なデータの流れを記述する。）

---

## 修正影響度チェックリスト

（変更時の影響範囲を確認するためのチェックリスト。）

---

## 関連ドキュメント

- 各モジュール解析: modules/*.md
- [結合ポイントマップ.md](../結合ポイントマップ.md)
- [ユースケース逆引き.md](../ユースケース逆引き.md)
- [潜在バグ一覧.md](潜在バグ一覧.md)（Phase 2 完了後）
