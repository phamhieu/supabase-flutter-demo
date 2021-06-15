# Supabase Demo App

A Flutter project to demo supabase dart client.

## Getting Started

Please update your `SUPABASE_URL` and `SUPABASE_ANNON_KEY` on `lib/constants.dart` before starting the app.

## Database schema

```
create table public.users (
  id          uuid not null primary key, -- UUID from auth.users
  email       text,
  data        jsonb
);
comment on table public.users is 'Profile data for each user.';
comment on column public.users.id is 'References the internal Supabase Auth user.';

-- Secure the tables
alter table public.users enable row level security;
create policy "Allow logged-in read access" on public.users for select using ( auth.role() = 'authenticated' );
create policy "Allow individual insert access" on public.users for insert with check ( auth.uid() = id );
create policy "Allow individual update access" on public.users for update using ( auth.uid() = id );

-- inserts a row into public.users
create function public.handle_new_user()
returns trigger as $$
begin
  insert into public.users (id, email)
  values (new.id, new.email);
  return new;
end;
$$ language plpgsql security definer;

-- trigger the function every time a user is created
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();
```

## Commands

- Launcher icons regenerate: `flutter pub run flutter_launcher_icons:main`
