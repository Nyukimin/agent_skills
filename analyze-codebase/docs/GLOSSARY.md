# 用語集

本スキルで使う用語を一箇所で定義する。SKILL および Phase 文書では定義を重複させず、本ファイルへの参照のみ行う。

---

## 地図原則

ドキュメントはソースコードの「代替」ではなく「地図 + 注意書き」として書く。ユーザーはソースコードとドキュメントの両方を LLM に渡す前提。シグネチャや実装詳細は転記せず、役割（Why）、関係性、構造マップ、落とし穴を記述する。

---

## モジュールグループ

プロファイルで定義する解析単位。各グループは id, name, dirs（対象ディレクトリ）, focus（重点ポイント）を持つ。Phase 1 の並列解析（Step 1-1 .. 1-N）は、プロファイルの module_groups の数だけ実行される。

---

## Phase 0a / Phase 0b

- **Phase 0a**: --refs が指定されたときのみ実行。外部資料（.md / .pdf）をプロファイルの refs_keywords でモジュールグループにマッピングし、refs_mapping.md を出力する。
- **Phase 0b**: phase1 または all のときに常時実行。既存調査記録（docs/調査/ 等）をスキャンし、モジュールグループと対応づける。結果は refs_mapping に統合するか survey_mapping.md に出力する。

---

## run_id

1回のスキル実行を一意に識別する ID。例: run_YYYYMMDD_HHMMSS（JST）。manifest.json の必須キー。--resume 時は既存 run の run_id を引き継ぐ。

---

## manifest

実行結果のメタデータを格納する JSON ファイル。{out}/manifest.json に出力する。必須キー: version, manifest_schema_version, run_id, target_dir, phase_requested, phase_done, profile_path, timestamp_start, timestamp_end, steps, errors。他スキル・ツールは manifest の存在と phase_done で解析結果の有無・鮮度を判定できる。詳細は CONTRACT および schema/manifest_schema.json を参照。

---

## refs_mapping

Phase 0a / 0b の結果をまとめたマッピング。外部資料や既存調査レポートをモジュールグループに対応づけた一覧。refs_mapping.md として出力するか、survey_mapping.md と統合するかはプロファイルで指定可能。

---

## 必須セクション

各成果物タイプ（モジュール解析、結合マップ、ユースケース逆引き等）について、テンプレートに含めるべき見出しの一覧。templates/schema/*.yaml で定義する。概要（2〜3行）と関連ドキュメントは全成果物で必須。

---

## CONTRACT

入出力・プロファイル・ステップの契約を唯一定義するファイル（CONTRACT.md）。手順は含めず契約のみを書く。他スキル・ツールは CONTRACT を読むだけで「何を渡し・何を読めばよいか」を把握できる。

---

## pipeline

実行するステップの一覧・Phase・依存（deps）・並列グループ・条件を定義する YAML（pipeline.yaml）。実行順序は pipeline を読んでトポロジカルソートで導出する。Phase 文書は「やり方」のみ記述し、「いつ実行するか」は pipeline を参照する。

---

## 部分成功

並列ステップ（1-1 .. 1-N）の一部が failed の場合でも、成功したモジュールのみを入力として Step 7, 8, 9 を実行すること。manifest の steps に failed を記録し、RUN_SUMMARY に部分成功の旨を記載する。

---

## --resume

既存の run を再開するためのオプション。--resume &lt;run_id&gt; 指定時、manifest を読み run_id が一致する run の steps のうち status === "done" のステップをスキップし、failed または未実行のステップから再実行する。run_id は新規発行せず引き継ぐ。
