-- ============================================================
-- Monthly Budget — one-time Supabase setup
-- Run in: Supabase dashboard -> your project -> SQL Editor -> New query -> Run
-- Project: https://xuipllbtrsebavtffjdy.supabase.co  (same one DivTracker uses)
-- ============================================================

create table if not exists public.budgets (
  id          text primary key,
  data        jsonb       not null default '{}'::jsonb,
  updated_at  timestamptz not null default now()
);

alter table public.budgets enable row level security;

-- Access model: anyone with the app's publishable (anon) key AND the secret
-- budget id (the #b=... in the share link) can read/write that budget.
drop policy if exists "budgets anon read"   on public.budgets;
drop policy if exists "budgets anon insert" on public.budgets;
drop policy if exists "budgets anon update" on public.budgets;
create policy "budgets anon read"   on public.budgets for select using (true);
create policy "budgets anon insert" on public.budgets for insert with check (true);
create policy "budgets anon update" on public.budgets for update using (true) with check (true);

grant select, insert, update on public.budgets to anon;
