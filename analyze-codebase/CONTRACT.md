# CONTRACT（契約）

本スキルの**契約**のみを定義する。手順は Phase 文書・テンプレートに記載する。他スキル・ツールは本ファイルと schema/ を参照すれば入出力を把握できる。

---

## 1. 入力契約

| 引数 | 必須 | 型 | デフォルト | 意味 |
|------|------|-----|------------|------|
| target_dir | ○ | path | — | 解析対象ルート |
| phase | — | enum | all | phase1 / phase2 / all |
| --refs | — | path | なし | 外部資料ディレクトリ（指定時のみ Phase 0a 実行） |
| --profile | — | path | 下記 | プロファイルファイル |
| --out | — | path | docs/codebase-map | 出力ベース |
| --resume | — | run_id | なし | 指定時、当該 run の done ステップをスキップして再開 |

- **--profile のデフォルト**: (1) `profiles/default.yaml` を読む。(2) 存在しなければ `{target_dir}/codebase-analysis-profile.yaml` を参照する。(3) どちらも存在しなければ失敗する。
- **--resume**: 指定時は `{out}/manifest.json` が存在し、かつ `run_id` が一致することを前提に、`steps[]` の `status === "done"` のステップはスキップし、`failed` または未実行のステップから再実行する。run_id は新規発行せず、既存 manifest の run_id を引き継ぐ。

---

## 2. 出力契約

### 2.1 出力ルート

- `{out}`（--out で指定。デフォルト `docs/codebase-map`）。

### 2.2 必須成果物

- **毎 run 終了時**: `manifest.json`, `RUN_SUMMARY.md`
- **Phase 0b 実行後**: `refs_mapping.md` または `survey_mapping.md`（プロファイルで統合するか別ファイルか指定可）
- **Phase 0a 実行時**: 上記に refs マッピングが統合されるか、`refs_mapping.md` が存在
- **Phase 1 完了後**: `modules/{module_group_id}.md`（プロファイルの各 module_groups）, `結合ポイントマップ.md`, `ユースケース逆引き.md`, `アーキテクチャ総合.md`
- **Phase 2 完了後**: 上記に加え `modules/潜在バグ一覧.md`（またはプロファイルの output.anomaly_file で名前変更可）

### 2.3 manifest スキーマ 1.0

- **必須キー**: `version`, `manifest_schema_version`, `run_id`, `target_dir`, `phase_requested`, `phase_done`, `profile_path`, `timestamp_start`, `timestamp_end`, `steps`, `errors`
- **任意キー**: `git_commit`, `git_branch`, `profile_schema_version`
- **steps 各要素**: `step_id`, `name`, `status`（done / skipped / failed）, `output`（成果物の相対パス）。任意で `started_at`, `finished_at`, `error`
- **errors**: 配列。要素は `{ step_id, message }` 形式。
- キー一覧の詳細は `schema/manifest_schema.json` を参照。

---

## 3. プロファイル契約

### 3.1 必須キー

- **name**: 文字列。プロファイル名。
- **module_groups**: 配列。各要素は以下を必須とする。
  - **id**: 文字列。step_id 1-1, 1-2, ... に対応する識別子。
  - **name**: 文字列。モジュールグループの表示名。
  - **dirs**: 配列（文字列）。解析対象ディレクトリの相対パス。
  - **focus**: 配列（文字列）。解析時の重点ポイント。

Phase 1 のみ実行する最小プロファイルは上記で足りる。

### 3.2 任意キー

- **refs_keywords**: オブジェクト。module_group.id をキー、キーワード配列を値とする。Phase 0a で --refs 内ファイルをモジュールグループにマッピングする際に使用。
- **use_cases**: 配列。各要素は `id`, `name` を持つ。Step 8（ユースケース逆引き）で使用。
- **output.base**: 出力ベースディレクトリの上書き。
- **output.modules_subdir**: モジュール解析成果物のサブディレクトリ名。
- **output.anomaly_file**: 異常一覧のファイル名（例: 潜在バグ一覧.md）。
- **anomaly_categories**, **severity_levels**: 異常一覧の分類・深刻度のカスタマイズ。
- **profile_schema_version**: 文字列（推奨 "1.0"）。manifest に記録し、他スキルが解釈を分岐するために使用。

検証ルールの詳細は `schema/profile_schema.json` を参照。

---

## 4. ステップ契約

### 4.1 step_id 一覧

- **0a**: refs マッピング。実行条件: `condition: refs_given`（--refs が指定されたときのみ）。
- **0b**: 既存調査マッピング。
- **1-1, 1-2, ... 1-N**: モジュール解析。N はプロファイルの `module_groups` の数。実行時に動的展開する。
- **7**: 結合ポイントマップ。
- **8**: ユースケース逆引き。
- **9**: アーキテクチャ総合。
- **10**: フォルダ概要の修正・補強。
- **11**: 結合・ユースケースの修正・補強。
- **12**: 全体概要の最終化。
- **13**: 異常一覧の生成。

### 4.2 実行順序・依存・並列

- 実行順序および依存関係（deps）、並列グループ（parallel_group）、条件（condition）は **pipeline.yaml** で定義する。本契約では step_id の一覧のみを規定し、いつ・どの順で実行するかは pipeline を参照すること。
