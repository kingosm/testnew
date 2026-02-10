-- CHECK YOUR ADMIN STATUS
-- Run this to see if you are actually an admin!
-- Replace 'kingosm2016@gmail.com' with your email if different.

SELECT 
    au.id, 
    au.email, 
    ur.role, 
    ur.created_at
FROM auth.users au
LEFT JOIN public.user_roles ur ON au.id = ur.user_id
WHERE au.email = 'kingosm2016@gmail.com';
