-- Supabase SQL Editor에서 한 번 실행하세요.
create table if not exists public.budget_entries (
 id uuid primary key, owner_id uuid not null default auth.uid() references auth.users(id),
 date date not null, kind text not null check (kind in ('income','expense')),
 amount numeric not null check (amount > 0), category text not null,
 person text not null, memo text not null
);
create table if not exists public.budget_repeats (
 id uuid primary key, owner_id uuid not null default auth.uid() references auth.users(id),
 name text not null, amount numeric not null check(amount > 0),
 day integer not null check(day between 1 and 31), category text not null,
 person text not null, start_month text not null
);
alter table public.budget_entries enable row level security;
alter table public.budget_repeats enable row level security;
create policy "owner only entries" on public.budget_entries for all to authenticated using (owner_id = auth.uid()) with check (owner_id = auth.uid());
create policy "owner only repeats" on public.budget_repeats for all to authenticated using (owner_id = auth.uid()) with check (owner_id = auth.uid());
grant select,insert,update,delete on public.budget_entries,public.budget_repeats to authenticated;
