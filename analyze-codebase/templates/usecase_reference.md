# ユースケース逆引きリファレンス テンプレート

以下のテンプレートに従って各ユースケースを解析すること。
ソースコードに書かれていない情報（判断ポイント、よくある誤解）を重視する。

**生成時に付与する frontmatter の例**:
```yaml
---
generated_at: "2025-02-27T15:00:00+09:00"
run_id: run_YYYYMMDD_HHMMSS
phase: 1
step: "8"
profile: {profile_name}
artifact: usecase_reference
---
```

**必須セクション**: templates/schema/usecase_required_sections.yaml を参照。

---

## 概要

（このドキュメントの目的: ユースケース別にトリガーと処理フローを逆引きできるようにする、を2〜3行で記述すること。）

---

## ユースケース: {use_case_name}

### トリガー
- {トリガーの説明}

### 処理フロー

1. **[トリガー受信]** `module/file.c` → `function_name()`
   - 説明
2. **[コマンド処理]** `module/file.c` → `function_name()`
   - 説明
3. **[状態遷移]** `state_machine/file.c` → `sm_dispatch(action)`
   - 説明
4. **[実行]** `module/file.c` → `function_name()`
   - 説明
5. **[ログ記録]** `logger/file.c` → `logger_log_set()`
   - 説明

### 判断ポイント（フロー中の重要な分岐）

| 箇所 | 条件 | True の場合 | False の場合 |
|------|------|-----------|------------|
| `file.c:行番号` | {分岐条件} | {処理A} | {処理B / エラーパス} |

※ 正常パスだけでなく、エラーパス・タイムアウト・例外ケースも記載する

### よくある誤解

- **誤解**: {よくある間違った理解}
  **実際**: {正しい動作とその理由}

### 状態遷移

- `state_before` → `state_after`（条件: xxx）

### 関連モジュール

module_a, module_b, module_c

### 関連ソースファイル

- `src/module/file.c:行番号` - 説明
- `src/module/file.h:行番号` - 説明

---

## 対象ユースケース一覧

プロファイルの use_cases に定義された各ユースケースについて、上記テンプレートに従って記述する。

## 関連ドキュメント

- [アーキテクチャ総合.md](../アーキテクチャ総合.md)
- [結合ポイントマップ.md](../結合ポイントマップ.md)
- 各モジュール解析: modules/*.md
