do $$
begin
  if to_regclass('public.profiles') is not null then
    execute 'alter table public.profiles enable row level security';
    execute 'drop policy if exists "Public read profiles" on public.profiles';
    execute 'create policy "Public read profiles" on public.profiles for select to anon, authenticated using (true)';
    execute 'drop policy if exists "Users update own profile" on public.profiles';
    execute ''
      create policy "Users update own profile"
      on public.profiles
      for update
      to authenticated
      using (auth.uid() = id)
      with check (auth.uid() = id)
    '';
  end if;

  if to_regclass('public.posts') is not null then
    execute 'alter table public.posts enable row level security';
    execute 'drop policy if exists "Public read posts" on public.posts';
    execute 'create policy "Public read posts" on public.posts for select to anon, authenticated using (true)';
    execute 'drop policy if exists "Users insert own posts" on public.posts';
    execute ''
      create policy "Users insert own posts"
      on public.posts
      for insert
      to authenticated
      with check (auth.uid() = user_id)
    '';
    execute 'drop policy if exists "Users update own posts" on public.posts';
    execute ''
      create policy "Users update own posts"
      on public.posts
      for update
      to authenticated
      using (auth.uid() = user_id)
      with check (auth.uid() = user_id)
    '';
    execute 'drop policy if exists "Users delete own posts" on public.posts';
    execute ''
      create policy "Users delete own posts"
      on public.posts
      for delete
      to authenticated
      using (auth.uid() = user_id)
    '';
  end if;

  if to_regclass('public.notifications') is not null then
    execute 'alter table public.notifications enable row level security';
    execute 'drop policy if exists "Users read own notifications" on public.notifications';
    execute ''
      create policy "Users read own notifications"
      on public.notifications
      for select
      to authenticated
      using (auth.uid() = user_id)
    '';
  end if;

  if to_regclass('public.followers') is not null then
    execute 'alter table public.followers enable row level security';
    execute 'drop policy if exists "Authenticated read followers" on public.followers';
    execute ''
      create policy "Authenticated read followers"
      on public.followers
      for select
      to authenticated
      using (true)
    '';
    execute 'drop policy if exists "Users follow as self" on public.followers';
    execute ''
      create policy "Users follow as self"
      on public.followers
      for insert
      to authenticated
      with check (auth.uid() = follower_id)
    '';
    execute 'drop policy if exists "Users unfollow as self" on public.followers';
    execute ''
      create policy "Users unfollow as self"
      on public.followers
      for delete
      to authenticated
      using (auth.uid() = follower_id)
    '';
  end if;
end
$$;