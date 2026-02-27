# Phase 1: トップダウン解析 詳細手順

## 目的（1行）

プロファイルの module_groups に従い並列でモジュール解析を行い、結合ポイントマップ・ユースケース逆引き・アーキテクチャ総合を順に生成する。

## 入力

- プロファイル（module_groups, use_cases, output）
- Phase 0 の出力（refs_mapping または survey_mapping。refs_list / survey_list として各 subagent に渡す）
- target_dir（解析対象ルート）

## 出力

- {out}/modules/{module_group_id}.md（プロファイルの各 module_groups に対応）
- {out}/結合ポイントマップ.md
- {out}/ユースケース逆引き.md
- {out}/アーキテクチャ総合.md

## 前提

- 実行順序・依存は [pipeline.yaml](../pipeline.yaml) を参照する。0b（および --refs 時は 0a）完了後、1-1..1-N を並列実行し、続けて 7 → 8 → 9 を実行する。
- Step 1-1..1-N の対象ディレクトリと重点ポイントは、プロファイルの module_groups[].dirs と module_groups[].focus から組み立てる。具体的なモジュール名・ディレクトリ名はプロファイルに定義される。

---

## Step 1-1 .. 1-N: モジュール解析（並列実行可能）

### 実行方法

Task ツールで subagent を起動し、プロファイルの module_groups の数だけ並列で解析する。各 subagent には次の入力を渡す。

- **module_group_id**, **module_group.name**: プロファイルの module_groups の要素から取得。
- **target_dirs**: プロファイルの module_groups[].dirs（target_dir からの相対パス）。
- **focus_points**: プロファイルの module_groups[].focus。
- **refs_list**: Phase 0a の結果からそのグループにマッピングされたファイル一覧（パス・図のページ番号）。
- **survey_list**: Phase 0b の結果からそのグループに関連する調査ファイル一覧。
- **output_path**: {out}/modules/{module_group_id}.md。
- **template**: templates/module_analysis.md。

各 subagent に渡すプロンプトの共通部分:

```
serena MCP を有効化し、指定された target_dirs を対象に以下のモジュールを解析せよ。

## 解析手順
0. 【refs_list が空でない場合】関連する設計書を読み込み、以下を把握:
   - .md ファイル: Read ツールで直接読み込む
   - .pdf ファイル: pdftotext でテキスト取得、図のページを pdftoppm で PNG 変換し Read で読み込む
   - 設計意図・仕様との乖離を「設計意図」「落とし穴・注意点」に反映する
1. get_symbols_overview でファイル内の関数一覧を取得
2. find_symbol で大関数（50行超）の body を取得
3. 大関数内の switch/case, if-else を分類・グループ化
4. find_referencing_symbols でモジュール間の関係を確認
5. search_for_pattern で暗黙のパターンを検出（fallthrough, 副作用のある分岐, エラーパス等）
6. templates/module_analysis.md に従い、地図原則でドキュメントを生成（役割・関係性・構造マップ・落とし穴を重視、シグネチャ転記は不要）

## 出力
Write ツールで output_path に書き出す。先頭に frontmatter（generated_at, run_id, phase: 1, step, profile, artifact: module, module_group_id）と概要・関連ドキュメントを付与すること。

## 外部資料（Phase 0 でマッピングされた設計書）
{refs_list}

## 関連調査（Phase 0b でマッピングされた調査レポート）
{survey_list}
```

---

## Step 7: モジュール結合ポイントマップ

### 前提

Step 1-1..1-N の出力が {out}/modules/ に存在すること。一部が failed の場合は成功したモジュールのみを入力とする。

### 手順

1. Step 1-1..1-N の成功した全出力を Read ツールで読み込む。
2. 各モジュールの「外部依存」「被依存」をクロスリファレンスする。
3. Middleware/Reducer/Observer 等のチェーンを優先度順に整理する。
4. templates/integration_map.md に従ってドキュメントを生成する。
5. 先頭に frontmatter と概要・関連ドキュメントを付与する。

### 出力

{out}/結合ポイントマップ.md

---

## Step 8: ユースケース逆引きリファレンス

### 前提

Step 1-1..1-N と Step 7 の出力が存在すること。プロファイルに use_cases が定義されていること。

### 手順

1. Step 1-1..1-N と Step 7 の出力を読み込む。
2. プロファイルの use_cases の各要素について、トリガーを特定し、コードを追跡して処理フローを構築する。各ステップの関数は find_symbol で確認する。
3. templates/usecase_reference.md に従って記述する。
4. 先頭に frontmatter と概要・関連ドキュメントを付与する。

### 出力

{out}/ユースケース逆引き.md

---

## Step 9: アーキテクチャ総合レポート

### 前提

Step 1-1..1-N と Step 7, 8 の出力が存在すること。

### 手順

1. 全出力を読み込み、システムアーキテクチャ概要・モジュール依存図・主要データフロー・修正影響度チェックリストを統合する。
2. templates/architecture_summary.md に従いドキュメントを生成する。先頭に frontmatter と概要・関連ドキュメントを付与する。
3. serena メモリにサマリを保存してもよい。

### 出力

{out}/アーキテクチャ総合.md

---

## manifest 更新

- 各ステップ開始時に manifest の steps に { step_id, name, status: "running", started_at } を追加する。
- 終了時に status: "done", finished_at, output を設定する。失敗時は status: "failed", error を設定し、errors 配列に { step_id, message } を追加する。
