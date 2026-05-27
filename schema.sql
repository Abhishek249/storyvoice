-- ── StoryVoice Database Schema ──

-- Projects: each user can have multiple stories
create table if not exists projects (
  id          uuid primary key default gen_random_uuid(),
  user_id     uuid references auth.users(id) on delete cascade not null,
  name        text not null,
  description text,
  created_at  timestamptz default now(),
  updated_at  timestamptz default now()
);

-- Characters: each project has its own cast
create table if not exists characters (
  id           uuid primary key default gen_random_uuid(),
  project_id   uuid references projects(id) on delete cascade not null,
  name         text not null,
  color        text default '#1a73e8',
  tts_provider text default 'elevenlabs', -- 'elevenlabs' | 'sarvam'
  voice_id     text,
  voice_name   text,
  stability    float default 0.5,
  similarity   float default 0.75,
  style        float default 0.3,
  sort_order   int  default 0,
  created_at   timestamptz default now()
);

-- User API keys (stored as plain text — user's own keys)
create table if not exists user_api_keys (
  user_id         uuid primary key references auth.users(id) on delete cascade,
  elevenlabs_key  text,
  sarvam_key      text,
  updated_at      timestamptz default now()
);

-- Row Level Security — users only see their own data
alter table projects       enable row level security;
alter table characters     enable row level security;
alter table user_api_keys  enable row level security;

-- Projects policies
create policy "users see own projects"
  on projects for all
  using (auth.uid() = user_id);

-- Characters policies
create policy "users see own characters"
  on characters for all
  using (
    project_id in (
      select id from projects where user_id = auth.uid()
    )
  );

-- API keys policies
create policy "users see own keys"
  on user_api_keys for all
  using (auth.uid() = user_id);

-- Auto-update updated_at
create or replace function update_updated_at()
returns trigger as $$
begin
  new.updated_at = now();
  return new;
end;
$$ language plpgsql;

create trigger projects_updated_at
  before update on projects
  for each row execute function update_updated_at();
