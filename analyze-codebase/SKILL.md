---
name: analyze-codebase
description: ソースコードを階層的に解析しドキュメント化する（Hierarchical Summarization）。LLM の「部分的に読んで理解した気になる」問題を解決するため、複数粒度で往復解析する。
argument-hint: "<target_dir> [phase1|phase2|all] [--refs <path>] [--profile <path>] [--out <path>] [--resume <run_id>]"
---

# Hierarchical Codebase Analysis

ソースコードを階層的に解析し、地図型ドキュメントとしてドキュメント化する。実行はプロファイル（YAML）と pipeline.yaml に従い、CONTRACT で定める入出力契約を満たす。

---

## 目次

1. [目的](#目的)
2. [引数・オプション](#引数オプション)
3. [入出力契約](#入出力契約)
4. [Phase 判定フロー](#phase-判定フロー)
5. [実行フロー](#実行フロー)
6. [共通ルール](#共通ルール)
7. [参照](#参照)

---

## 目的

- 対象ディレクトリを**階層的に解析**し、**地図型ドキュメント**（役割・関係性・構造マップ・落とし穴）を生成する。
- 他スキル・ツールとの連携を視野に、入出力は [CONTRACT.md](CONTRACT.md) で明確に定義する。
- 用語の定義は [docs/GLOSSARY.md](docs/GLOSSARY.md) を参照すること。

---

## 引数・オプション

| 引数 | 必須 | デフォルト | 意味 |
|------|------|------------|------|
| target_dir | ○ | — | 解析対象ルート |
| phase | — | all | phase1 / phase2 / all |
| --refs &lt;path&gt; | — | なし | 外部資料ディレクトリ（指定時のみ Step 0a 実行） |
| --profile &lt;path&gt; | — | 下記 | プロファイルファイル |
| --out &lt;path&gt; | — | docs/codebase-map | 出力ベース |
| --resume &lt;run_id&gt; | — | なし | 当該 run の done ステップをスキップして再開 |

--profile のデフォルト: (1) `profiles/default.yaml`、(2) なければ `{target_dir}/codebase-analysis-profile.yaml`。どちらもなければ失敗する。

詳細は [CONTRACT.md](CONTRACT.md) の「入力契約」を参照。

---

## 入出力契約

- **入力**: CONTRACT の「入力契約」に従う。
- **出力**: CONTRACT の「出力契約」に従う。出力ルートは `{out}`。必須成果物に manifest.json, RUN_SUMMARY.md および Phase 別の成果物が含まれる。
- **manifest**: スキーマ 1.0。run_id, steps, errors, timestamp_start/end 等。他スキル・ツールは manifest の存在と phase_done で解析結果の有無・鮮度を判定できる。
- 詳細は [CONTRACT.md](CONTRACT.md) および [schema/manifest_schema.json](schema/manifest_schema.json) を参照。

---

## Phase 判定フロー

- **phase が phase1**: Phase 0b を実行し、--refs 指定時は Phase 0a も実行。続けて Phase 1（Step 1-1..1-N → 7 → 8 → 9）を実行。実行順・条件は [pipeline.yaml](pipeline.yaml) を参照。
- **phase が phase2**: Phase 2 のみ実行。前提として {out}/manifest.json が存在し、phase_done が Phase 1 完了以上であること。満たさなければ「Phase 1 を先に実行してください」とし終了。
- **phase が all または未指定**: 上記 phase1 の後に Phase 2（Step 10→11→12→13）を続けて実行。

---

## 実行フロー

1. **引数解析**: target_dir, phase, --refs, --profile, --out, --resume を確定する。
2. **プロファイル読み込み**: --profile のデフォルトルールに従い YAML を読む。CONTRACT の「プロファイル契約」または schema/profile_schema.json で必須キー（name, module_groups 各要素の id/name/dirs/focus）を検証する。必須キー欠落・型不整合の場合はステップを1つも実行せずにエラー終了する。
3. **--resume の場合**: {out}/manifest.json を読み、指定 run_id と一致するか確認する。一致しなければエラー。一致すれば steps の status === "done" のステップをスキップ対象とし、failed または未実行から再実行する。run_id は新規発行せず引き継ぐ。
4. **--resume でない場合**: run_id を発行する（例: run_YYYYMMDD_HHMMSS、JST）。manifest を初期化する。初期化時の形の例:
   ```json
   {
     "version": "1.0",
     "manifest_schema_version": "1.0",
     "run_id": "run_YYYYMMDD_HHMMSS",
     "target_dir": "{target_dir}",
     "phase_requested": "phase1|phase2|all",
     "phase_done": "",
     "profile_path": "{profile_path}",
     "timestamp_start": "{ISO8601}",
     "timestamp_end": "",
     "steps": [],
     "errors": []
   }
   ```
5. **pipeline に従う実行**: [pipeline.yaml](pipeline.yaml) を読み、phase に応じた実行計画を組み立てる。0b →（--refs 時は 0a）→ 1-1..1-N（並列）→ 7 → 8 → 9 →（Phase 2 なら 10→11→12→13）。各ステップ開始時に manifest の steps に { step_id, name, status: "running", started_at } を追加する。手順は [phases/](phases/) の該当 Phase 文書に従う。ステップ終了時に該当 step の status, finished_at, output を設定する。生成したファイルには CONTRACT で定める frontmatter（generated_at, run_id, phase, step）と概要・関連ドキュメントを付与する。
6. **部分成功**: 並列ステップ（1-1..1-N）の一部が failed の場合、成功したモジュールのみを入力として Step 7, 8, 9 を実行する。manifest の steps に failed を記録し、errors に { step_id, message } を追加する。RUN_SUMMARY に部分成功の旨を記載する。
7. **Phase 終了時**: manifest の timestamp_end と phase_done を更新する。[templates/run_summary.md](templates/run_summary.md) の必須見出し（実行概要、ステップ結果、成果物一覧、失敗時、次の一手）に従い RUN_SUMMARY.md を生成し {out} に書き出す。続けて manifest を {out}/manifest.json に書き出す。

---

## 共通ルール

1. **serena MCP のシンボル解析ツールを優先**
   - `get_symbols_overview` → `find_symbol` → `find_referencing_symbols` の順で使う。
   - ファイル全体の読み込みは最小限にする。
   - まず .h（公開API）を読み、必要に応じて .c を参照する。

2. **推測と事実を区別**
   - コードから確認した事実はそのまま記述する。
   - 推測は「※推測」タグを付ける。

3. **各ステップ完了時にファイル書き出し**
   - 中断しても再開可能にする。
   - 出力は {out} に書き出す。serena メモリにサマリを保存してもよい。

4. **manifest と RUN_SUMMARY**
   - ステップ開始時に manifest の steps に step を追加し、終了時に status, finished_at, output を設定する。
   - Phase 終了時に RUN_SUMMARY.md をテンプレートに従って生成する。

5. **地図原則**（用語は [docs/GLOSSARY.md](docs/GLOSSARY.md) を参照）
   - ドキュメントはソースコードの「代替」ではなく「地図 + 注意書き」とする。
   - シグネチャや実装詳細は転記せず、役割（Why）、関係性、構造マップ、落とし穴を記述する。

6. **生成物の共通ヘッダー**
   - 全生成 Markdown の先頭に YAML frontmatter（generated_at, run_id, phase, step, profile 等）を付与する。
   - 先頭に「概要（2〜3行）」と「関連ドキュメント」セクションを必須とする。

---

## 参照

- **契約**: [CONTRACT.md](CONTRACT.md)（入出力・プロファイル・ステップ契約の唯一定義）
- **実行順・依存**: [pipeline.yaml](pipeline.yaml)
- **手順**: [phases/phase0_refs.md](phases/phase0_refs.md), [phases/phase0_survey.md](phases/phase0_survey.md), [phases/phase1_topdown.md](phases/phase1_topdown.md), [phases/phase2_bottomup.md](phases/phase2_bottomup.md)
- **テンプレート**: [templates/](templates/)
- **プロファイル**: [profiles/](profiles/)
- **用語**: [docs/GLOSSARY.md](docs/GLOSSARY.md)
