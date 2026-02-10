-- Make User an Admin
-- Targeted Email: kingosm42@gmail.com

DO $$
DECLARE
  target_email TEXT := 'kingosm42@gmail.com'; -- Email set as requested
  target_user_id UUID;
BEGIN
  -- Find the user by email
  SELECT id INTO target_user_id FROM auth.users WHERE email = target_email;

  IF target_user_id IS NOT NULL THEN
    -- precise upsert for user_roles
    INSERT INTO public.user_roles (user_id, role)
    VALUES (target_user_id, 'super_admin')
    ON CONFLICT (user_id, role) DO NOTHING;
    
    RAISE NOTICE 'User % matches and has been made super_admin.', target_email;
  ELSE
    RAISE NOTICE 'User with email % not found. Please sign up first.', target_email;
  END IF;
END $$;
