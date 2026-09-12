-- =========================================================
-- WATCHIT database schema (PostgreSQL / Supabase)
-- Run once: Supabase Dashboard -> SQL Editor -> New query -> paste all -> Run
-- Safe to run more than once (uses "if not exists" / "on conflict").
-- =========================================================

create extension if not exists "uuid-ossp";

-- ---------- Categories (genres) ----------
create table if not exists categories (
  id uuid primary key default uuid_generate_v4(),
  name text not null,
  type text not null check (type in ('movie','music')),
  created_at timestamptz default now(),
  unique (name, type)
);

-- ---------- Movies ----------
create table if not exists movies (
  id uuid primary key default uuid_generate_v4(),
  title text not null,
  description text,
  poster_url text,
  category_id uuid references categories(id) on delete set null,
  release_year int,
  duration_text text,
  source_url text,
  trailer_url text,
  featured boolean default false,
  created_at timestamptz default now()
);

-- ---------- Songs ----------
create table if not exists songs (
  id uuid primary key default uuid_generate_v4(),
  title text not null,
  artist text,
  album text,
  cover_url text,
  category_id uuid references categories(id) on delete set null,
  release_year int,
  audio_url text,
  description text,
  featured boolean default false,
  created_at timestamptz default now()
);

-- ---------- Site settings (single row) ----------
create table if not exists site_settings (
  id int primary key default 1,
  site_name text default 'WATCHIT',
  tagline text default 'Movies and music, curated by one admin.',
  constraint single_row check (id = 1)
);
insert into site_settings (id) values (1) on conflict (id) do nothing;

-- ---------- Seed default categories ----------
insert into categories (name, type) values
  ('Action','movie'), ('Comedy','movie'), ('Drama','movie'),
  ('Animation','movie'), ('Documentary','movie'), ('Adventure','movie'),
  ('Afrobeats','music'), ('Hip-Hop','music'), ('Gospel','music'),
  ('R&B','music'), ('Pop','music'), ('Other','music')
on conflict do nothing;

-- =========================================================
-- Row Level Security (RLS)
-- Rule of thumb: everyone can READ, only a signed-in user can WRITE.
-- Since this project will only ever have ONE account (you, the admin),
-- "signed in" and "admin" mean the same thing here.
-- =========================================================
alter table movies enable row level security;
alter table songs enable row level security;
alter table categories enable row level security;
alter table site_settings enable row level security;

drop policy if exists "Public read movies" on movies;
create policy "Public read movies" on movies for select using (true);

drop policy if exists "Public read songs" on songs;
create policy "Public read songs" on songs for select using (true);

drop policy if exists "Public read categories" on categories;
create policy "Public read categories" on categories for select using (true);

drop policy if exists "Public read settings" on site_settings;
create policy "Public read settings" on site_settings for select using (true);

drop policy if exists "Admin write movies insert" on movies;
create policy "Admin write movies insert" on movies for insert to authenticated with check (true);
drop policy if exists "Admin write movies update" on movies;
create policy "Admin write movies update" on movies for update to authenticated using (true);
drop policy if exists "Admin write movies delete" on movies;
create policy "Admin write movies delete" on movies for delete to authenticated using (true);

drop policy if exists "Admin write songs insert" on songs;
create policy "Admin write songs insert" on songs for insert to authenticated with check (true);
drop policy if exists "Admin write songs update" on songs;
create policy "Admin write songs update" on songs for update to authenticated using (true);
drop policy if exists "Admin write songs delete" on songs;
create policy "Admin write songs delete" on songs for delete to authenticated using (true);

drop policy if exists "Admin write categories insert" on categories;
create policy "Admin write categories insert" on categories for insert to authenticated with check (true);
drop policy if exists "Admin write categories update" on categories;
create policy "Admin write categories update" on categories for update to authenticated using (true);
drop policy if exists "Admin write categories delete" on categories;
create policy "Admin write categories delete" on categories for delete to authenticated using (true);

drop policy if exists "Admin write settings" on site_settings;
create policy "Admin write settings" on site_settings for update to authenticated using (true);
