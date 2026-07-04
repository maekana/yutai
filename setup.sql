-- ============================================================
-- 優待手帳：Supabase テーブル作成SQL
-- Supabase ダッシュボード → SQL Editor に貼り付けて実行してください
-- ============================================================

-- 銘柄マスタ（PK：コード × 証券口座）
create table if not exists yutai_master (
  code            text not null,            -- コード（半角英数）
  account         text not null,            -- 証券口座（SBI/楽天/マネックス）
  name            text not null,            -- 銘柄名
  format          text not null default '紙',   -- 形式（紙/電子/アプリ）
  benefit_type    text not null default '金額', -- 優待種類（金額/枚数）
  times_per_year  int  not null default 1,      -- 年優待回数（1 or 2）
  month1          int,                      -- 回1：優待月
  expiry_months1  int,                      -- 回1：有効期限（nか月後）
  amount1         numeric,                  -- 回1：優待額
  month2          int,                      -- 回2：優待月
  expiry_months2  int,                      -- 回2：有効期限（nか月後）
  amount2         numeric,                  -- 回2：優待額
  url             text,                     -- URL（電子のみ）
  login_id        text,                     -- ID（電子のみ）
  login_pass      text,                     -- PASS（電子のみ）
  memo            text,                     -- メモ(マスタ)
  created_at      timestamptz default now(),
  updated_at      timestamptz default now(),
  primary key (code, account)
);

-- 残額データ（PK：コード × 証券口座 × 有効期限）
-- マスタ削除後もデータが残るよう、マスタ項目をコピーして保持（外部キーなし）
create table if not exists yutai_balance (
  code          text not null,
  account       text not null,
  expiry        date not null,              -- 有効期限
  name          text,
  format        text,
  benefit_type  text,
  amount        numeric,                    -- 優待額
  balance       numeric,                    -- 残額
  url           text,
  login_id      text,
  login_pass    text,
  memo_master   text,                       -- メモ(マスタ)
  memo_tran     text,                       -- メモ(トラン)
  created_at    timestamptz default now(),  -- 登録日
  updated_at    timestamptz default now(),  -- 最終更新日
  primary key (code, account, expiry)
);

-- RLS（行レベルセキュリティ）を有効化
alter table yutai_master  enable row level security;
alter table yutai_balance enable row level security;

-- 匿名キーでの読み書きを許可するポリシー
-- ※URLとanonキーを知っている人は誰でも読み書きできる設定です。
--   ID/PASSを保存するため、公開リポジトリにキーを載せない・
--   将来的にはSupabase Auth導入を推奨します。
create policy "anon all master"  on yutai_master  for all using (true) with check (true);
create policy "anon all balance" on yutai_balance for all using (true) with check (true);
