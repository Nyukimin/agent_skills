# モジュール結合ポイントマップ テンプレート

以下のテンプレートに従って結合ポイントを分析すること。

**生成時に付与する frontmatter の例**:
```yaml
---
generated_at: "2025-02-27T15:00:00+09:00"
run_id: run_YYYYMMDD_HHMMSS
phase: 1
step: "7"
profile: {profile_name}
artifact: integration_map
---
```

**必須セクション**: templates/schema/integration_map_required_sections.yaml を参照。

---

## 概要

（全体のデータフロー・結合の考え方を2〜3行で要約すること。）

---

## アーキテクチャ概要

### Dux（Redux風）アーキテクチャ データフロー

（ASCII図でデータフローを記述）

```
Action → Middleware Chain → Reducer Chain → State → Observer Chain
```

### 状態ツリー構造

（SM_State のメンバーをツリー形式で記述）

## モジュール間依存関係マトリクス

### 凡例
- **R**: Reducer 登録（SM_REDUCER_REGISTER）
- **O**: Observer 登録（SM_OBSERVER_REGISTER）
- **M**: Middleware 登録（SM_MIDDLEWARE_REGISTER）
- **A**: Action dispatch（sm_dispatch 経由）
- **D**: API 直接呼び出し

### コア基盤 → 他モジュール

| 呼び出し元 | 呼び出し先 | 種別 | なぜこの依存が必要か |
|-----------|-----------|------|-------------------|
| module_a | module_b | R/O/M/A/D | {この依存が存在する理由} |

（カテゴリごとに繰り返し）

## Middleware チェーン（実行順）

| 優先度 | モジュール | 処理内容 |
|--------|-----------|---------|
| {priority} | {module} | {description} |

## Reducer チェーン（実行順）

| 優先度 | モジュール | 処理対象 |
|--------|-----------|---------|
| {priority} | {module} | {description} |

## Observer チェーン

| モジュール | 監視対象状態 | トリガー条件 |
|-----------|------------|------------|
| {module} | {state_member} | {condition} |

## 関連ドキュメント

- [アーキテクチャ総合.md](../アーキテクチャ総合.md)
- [ユースケース逆引き.md](../ユースケース逆引き.md)
- 各モジュール解析: modules/*.md
