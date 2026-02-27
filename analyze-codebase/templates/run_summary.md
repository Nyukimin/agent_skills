# RUN_SUMMARY テンプレート

毎 run の最後に上書きする人間向け実行サマリ。以下の必須見出しと内容を満たすこと。

---

## 実行概要

- **run_id**: {run_id}
- **要求 phase**: {phase_requested}
- **実行日時**: {timestamp_start} ～ {timestamp_end}
- **対象ディレクトリ**: {target_dir}
- **プロファイル**: {profile_path}

---

## ステップ結果

| step_id | name | status | output |
|---------|------|--------|--------|
| 0b | 既存調査マッピング | done | refs_mapping.md |
| 1-1 | core | done | modules/core.md |
| ... | ... | ... | ... |

（実際の steps の内容を表形式で記載する。status は done / skipped / failed。）

---

## 成果物一覧

| パス | 説明 |
|------|------|
| manifest.json | 実行メタデータ |
| RUN_SUMMARY.md | 本サマリ |
| refs_mapping.md | 外部資料・調査マッピング |
| modules/*.md | モジュール解析・異常一覧 |
| 結合ポイントマップ.md | モジュール間結合 |
| ユースケース逆引き.md | ユースケース別処理フロー |
| アーキテクチャ総合.md | 全体レポート |

（実際に生成された成果物のみ記載する。）

---

## 失敗時

（errors が空でない場合のみこのセクションを記載する。）

- **step_id**: {step_id}
- **理由**: {message}

再実行するには: `--resume {run_id}` で phase を指定して実行すること。

---

## 次の一手

（phase_done が phase2 でない場合、または errors がある場合に記載する。）

- phase2 未実行の場合: 「Phase 2 を実行すると修正・異常一覧まで完了します。」
- 一部ステップが failed の場合: 「--resume {run_id} で失敗ステップから再実行できます。」
