-- Snapshot safety net for DivTracker + Budget.
-- Run once in the Supabase dashboard: SQL Editor -> New query -> paste -> Run.
-- Keeps automatic point-in-time copies of each app's data (the apps prune to
-- the newest ~30 per app), with a "Restore" picker inside each app.

create table if not exists public.snapshots (
  id bigint generated always as identity primary key,
  user_id uuid not null references auth.users(id) on delete cascade,
  app text not null,
  data jsonb not null,
  created_at timestamptz not null default now()
);

alter table public.snapshots enable row level security;

drop policy if exists "snapshots select own" on public.snapshots;
create policy "snapshots select own" on public.snapshots
  for select using (auth.uid() = user_id);

drop policy if exists "snapshots insert own" on public.snapshots;
create policy "snapshots insert own" on public.snapshots
  for insert with check (auth.uid() = user_id);

drop policy if exists "snapshots delete own" on public.snapshots;
create policy "snapshots delete own" on public.snapshots
  for delete using (auth.uid() = user_id);

create index if not exists snapshots_user_app_idx
  on public.snapshots (user_id, app, created_at desc);
