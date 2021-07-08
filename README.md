# Supabase Flutter User Management

This example will set you up for a very common situation: users can sign up with a magic link and then update their account with public profile information, including a profile image.

## Getting Started

- Update your `SUPABASE_URL` and `SUPABASE_ANNON_KEY` [here](https://github.com/phamhieu/supabase-flutter-demo/blob/4fc589ed88cdecc0fc683d30063bb3848acc2a26/lib/utils/constants.dart#L5-L6)
- Update your app custom `SCHEME` and `HOSTNAME` [here](https://github.com/phamhieu/supabase-flutter-demo/blob/4fc589ed88cdecc0fc683d30063bb3848acc2a26/lib/utils/constants.dart#L2)
- Follow the guide [here](https://github.com/supabase/supabase-flutter#deeplink-config) to config deeplink and supabase project 3rd party login.

## Database schema

```
-- Create a table for Public Profiles
create table profiles (
  id uuid references auth.users not null,
  updated_at timestamp with time zone,
  username text unique,
  avatar_url text,
  website text,

  primary key (id),
  unique(username),
  constraint username_length check (char_length(username) >= 3)
);

alter table profiles enable row level security;

create policy "Public profiles are viewable by everyone."
  on profiles for select
  using ( true );

create policy "Users can insert their own profile."
  on profiles for insert
  with check ( auth.uid() = id );

create policy "Users can update own profile."
  on profiles for update
  using ( auth.uid() = id );

-- Set up Realtime!
begin;
  drop publication if exists supabase_realtime;
  create publication supabase_realtime;
commit;
alter publication supabase_realtime add table profiles;

-- Set up Storage!
insert into storage.buckets (id, name)
values ('avatars', 'avatars');

create policy "Avatar images are publicly accessible."
  on storage.objects for select
  using ( bucket_id = 'avatars' );

create policy "Anyone can upload an avatar."
  on storage.objects for insert
  with check ( bucket_id = 'avatars' );
```

## Commands

- Launcher icons regenerate: `flutter pub run flutter_launcher_icons:main`
