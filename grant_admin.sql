-- Grant super_admin role to the user
-- Run this in your Supabase SQL Editor
INSERT INTO public.user_roles (user_id, role)
VALUES ('4c1588fb-c1fc-42ca-af50-21d35809dad2', 'super_admin')
ON CONFLICT (user_id, role) DO NOTHING;
