-- 1) Replace YOUR_EMAIL with the email you'll use to log in to the dashboard.
-- 2) Run this whole file in Supabase > SQL Editor.

create table if not exists notes (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default now(),
  subject text not null,
  filename text not null,
  path text not null,
  mime text,
  size bigint
);
alter table notes enable row level security;

-- Smartboard account: can only ADD notes
create policy "board adds notes" on notes for insert to authenticated
  with check (auth.jwt()->>'email' = 'uploader@board.local');

-- You: full access
create policy "owner manages notes" on notes for all to authenticated
  using (auth.jwt()->>'email' = 'tanmaykanoo30@gmail.com')
  with check (auth.jwt()->>'email' = 'tanmaykanoo30@gmail.com');

-- Private storage bucket
insert into storage.buckets (id, name, public) values ('notes', 'notes', false)
on conflict (id) do nothing;

create policy "board uploads files" on storage.objects for insert to authenticated
  with check (bucket_id = 'notes' and auth.jwt()->>'email' = 'uploader@board.local');

create policy "owner reads files" on storage.objects for select to authenticated
  using (bucket_id = 'notes' and auth.jwt()->>'email' = 'tanmaykanoo30@gmail.com');

create policy "owner deletes files" on storage.objects for delete to authenticated
  using (bucket_id = 'notes' and auth.jwt()->>'email' = 'tanmaykanoo30@gmail.com');
