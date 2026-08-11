-- Government Support Workspace schema for Supabase / PostgreSQL
-- Generated: 2026-08-11

create table if not exists public.gov_support_workspace (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid not null references auth.users(id) on delete cascade,
  workspace_key text not null default 'main',
  payload jsonb not null default '{"notices":[],"history":[]}'::jsonb,
  updated_at timestamptz not null default now(),
  created_at timestamptz not null default now(),
  constraint gov_support_workspace_owner_key_unique unique(owner_id, workspace_key)
);

alter table public.gov_support_workspace enable row level security;

revoke all on table public.gov_support_workspace from anon;
revoke all on table public.gov_support_workspace from authenticated;
grant select, insert, update, delete on table public.gov_support_workspace to authenticated;

drop policy if exists "gov_support_select_own" on public.gov_support_workspace;
create policy "gov_support_select_own"
on public.gov_support_workspace
for select
to authenticated
using ((select auth.uid()) = owner_id);

drop policy if exists "gov_support_insert_own" on public.gov_support_workspace;
create policy "gov_support_insert_own"
on public.gov_support_workspace
for insert
to authenticated
with check ((select auth.uid()) = owner_id);

drop policy if exists "gov_support_update_own" on public.gov_support_workspace;
create policy "gov_support_update_own"
on public.gov_support_workspace
for update
to authenticated
using ((select auth.uid()) = owner_id)
with check ((select auth.uid()) = owner_id);

drop policy if exists "gov_support_delete_own" on public.gov_support_workspace;
create policy "gov_support_delete_own"
on public.gov_support_workspace
for delete
to authenticated
using ((select auth.uid()) = owner_id);

create table if not exists public.gov_support_seed (
  seed_date date primary key,
  payload jsonb not null,
  created_at timestamptz not null default now()
);

alter table public.gov_support_seed enable row level security;
grant select on table public.gov_support_seed to authenticated;

drop policy if exists "gov_support_seed_read" on public.gov_support_seed;
create policy "gov_support_seed_read"
on public.gov_support_seed
for select
to authenticated
using (true);
