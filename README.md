# 優待手帳

株主優待の残額と期限を管理するPWAです（GitHub Pages + Supabase同期）。

## セットアップ手順
1. Supabaseのプロジェクトで SQL Editor を開き、`setup.sql` を実行する（テーブル2つとRLSポリシーが作成されます）
2. `index.html` 冒頭の `SUPABASE_URL` と `SUPABASE_ANON_KEY` を自分のプロジェクトの値に書き換える
   （Settings → API → Project URL / anon public key）
3. リポジトリにファイル一式を配置し、GitHub Pages を有効化する
4. iPhone/iPadのSafariで開き「ホーム画面に追加」

## ファイル構成
- index.html … アプリ本体（画面・ロジックすべて）
- manifest.json / sw.js / icon-*.png … PWA用
- setup.sql … Supabaseテーブル作成SQL

## 仕組みメモ
- 残額データはマスタの項目をコピーして保持するため、マスタを削除しても残額データは消えません
- 優待の自動登録はアプリ起動時に判定します（優待月の1日以降で、該当キーの残額データが未作成なら生成）
- 残額が0になった優待は一覧から非表示になります（「使用済も表示」トグルで表示可能）

## セキュリティ上の注意
- 電子優待のID/PASSを平文で保存します。anonキーとURLを知っている人は誰でも読み書きできる設定のため、
  リポジトリを公開する場合はキーの扱いに注意してください。将来的にはSupabase Authの導入を推奨します。
