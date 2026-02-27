# Phase 0b: 既存調査マッピング

## 目的（1行）

既存調査記録（docs/調査/ 等）をスキャンし、プロファイルのモジュールグループと対応づけ、Phase 1 の subagent に「関連調査」として渡す。

## 入力

- 既存調査記録のディレクトリ（デフォルトは docs/調査/。プロファイルで上書き可能）
- プロファイルの module_groups（モジュールグループ一覧）

## 出力

- refs_mapping.md に統合するか、{out}/survey_mapping.md に出力する。プロファイルで指定がない場合は refs_mapping に統合する形で記載する。
- Phase 1 の各 subagent には、本 Phase の結果からそのグループに関連する調査ファイル一覧（survey_list）を渡す。

## 前提

- 実行順序は pipeline を参照する。Phase 1 の前に実行する。
- Phase 2 の Step 13 で過去調査との重複チェックに本マッピングを使用する。

---

## 手順

1. 既存調査記録ディレクトリ（例: docs/調査/）内のファイルを Glob で一覧取得する。
2. 各調査レポートのタイトル・冒頭から関連モジュールを推定する。
3. プロファイルの module_groups と照合し、モジュールグループとのマッピングを生成する（refs マッピングと同じ形式で、ファイルパスとモジュールグループ id の対応）。
4. 結果を refs_mapping.md に追記するか、survey_mapping.md に書き出す。
5. Phase 1 の各 subagent プロンプトに、関連する過去調査のパス（survey_list）を追加する。

---

## manifest 更新

- 本ステップ（0b）開始時に manifest の steps に { step_id: "0b", name: "既存調査マッピング", status: "running", started_at } を追加する。
- 終了時に status: "done", finished_at, output を設定する。
