# Phase 0a: refs マッピング

## 目的（1行）

--refs が指定されたとき、外部資料（.md / .pdf）をプロファイルの refs_keywords でモジュールグループにマッピングし、refs_mapping.md を出力する。

## 入力

- --refs で指定されたディレクトリ配下の .md / .pdf ファイル
- プロファイルの refs_keywords（module_group.id → キーワード配列）

## 出力

- {out}/refs_mapping.md（設計書・仕様書とモジュールグループの対応、PDF の場合は図を含むページ番号も記録）

## 前提

- 実行条件: pipeline で `condition: refs_given` のときのみ実行する。--refs が指定されていない場合は本 Phase はスキップする。
- PDF の図を読み込むには `poppler` が必要（`brew install poppler`）。pdftotext（テキスト抽出）と pdftoppm（ページ画像変換）を使用する。

---

## 手順

1. --refs ディレクトリ内の .md / .pdf ファイルを一覧取得する。
2. 各ファイルの内容を取得する。
   - **.md ファイル**: Read ツールで直接読み込み（タイトル + 冒頭10行程度）。
   - **.pdf ファイル**:
     a. Bash で `pdftotext <file> -` を実行しテキスト全文を取得（目次・構造の把握）。
     b. テキストから図を含むページを特定（「図」「レイヤー」「フロー」「構成」等のキーワード、または目次構造から推定）。
     c. 該当ページのみ Bash で `pdftoppm -png -r 200 -f N -l N <file> /tmp/pdf_<name>` で PNG 変換。
     d. Read ツールで PNG を読み込み、図の内容（アーキテクチャ図、フロー図、状態遷移図等）を把握する。
3. プロファイルの refs_keywords を用い、ファイル名・タイトル・図の内容から機能キーワードを抽出し、各モジュールグループ（プロファイルの module_groups）とキーワードマッチでマッピングを生成する。1つの設計書が複数グループにマッチしてもよい。
4. マッピング結果を {out}/refs_mapping.md に書き出す。PDF の場合は図を含むページ番号も記録する（Phase 1 の subagent に渡すため）。
5. Phase 1 の各 subagent には、Phase 0 の結果からそのグループにマッピングされたファイル一覧（refs_list）を渡す。

---

## manifest 更新

- 本ステップ（0a）開始時に manifest の steps に { step_id: "0a", name: "refs マッピング", status: "running", started_at } を追加する。
- 終了時に status: "done", finished_at, output: "refs_mapping.md" を設定する。
- 生成した refs_mapping.md には frontmatter（generated_at, run_id, phase: 0, step: "0a"）と概要・関連ドキュメントを付与する。
