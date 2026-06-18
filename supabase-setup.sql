-- ============================================================
-- Monthly Budget — one-time Supabase setup (per-account, private)
-- Run in: Supabase dashboard -> your project -> SQL Editor -> New query -> Run
-- Project: https://xuipllbtrsebavtffjdy.supabase.co  (same one DivTracker uses)
-- ============================================================

-- Drops any earlier (shared/id-based) budgets table so this fresh per-account
-- one is created cleanly. Safe for first-time setup; the app does not read the old table.
drop table if exists public.budgets;

create table public.budgets (
  user_id     uuid        primary key references auth.users(id) on delete cascade,
  data        jsonb       not null default '{}'::jsonb,
  updated_at  timestamptz not null default now()
);

alter table public.budgets enable row level security;

-- Each signed-in user can only see and change THEIR OWN row.
drop policy if exists "own budget select" on public.budgets;
drop policy if exists "own budget insert" on public.budgets;
drop policy if exists "own budget update" on public.budgets;
create policy "own budget select" on public.budgets for select using (auth.uid() = user_id);
create policy "own budget insert" on public.budgets for insert with check (auth.uid() = user_id);
create policy "own budget update" on public.budgets for update using (auth.uid() = user_id) with check (auth.uid() = user_id);

grant select, insert, update on public.budgets to authenticated;

-- ============================================================
-- ALSO do this in the dashboard (not SQL):
--  1. Authentication -> Providers -> Email: make sure it's ENABLED.
--  2. (Optional, for instant signups) Authentication -> Providers -> Email
--     -> turn OFF "Confirm email" so new users can sign in immediately.
--     Leave it ON if you want users to verify their email first.
--  3. Authentication -> URL Configuration -> Site URL:
--     set to  https://rustygator5.github.io/budget/
--     (used for password-reset links).
-- ============================================================
