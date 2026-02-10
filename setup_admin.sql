-- Grants super_admin privileges to a user by their email
-- Usage: Replace 'YOUR_EMAIL_HERE' with the actual user's email address

DO $$
DECLARE
  target_user_id UUID;
  target_email TEXT := 'YOUR_EMAIL_HERE'; -- <--- ENTER YOUR EMAIL HERE
BEGIN
  -- Find the user ID based on the email
  SELECT id INTO target_user_id FROM auth.users WHERE email = target_email;

  IF target_user_id IS NULL THEN
    RAISE EXCEPTION 'User with email % not found', target_email;
  END IF;

  -- Insert the role if it doesn't exist
  INSERT INTO public.user_roles (user_id, role)
  VALUES (target_user_id, 'super_admin')
  ON CONFLICT (user_id, role) DO NOTHING;

  RAISE NOTICE 'Granted super_admin role to % (ID: %)', target_email, target_user_id;
END $$;
