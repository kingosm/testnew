-- ============================================
-- Admin Helper: Reset Username Change Permission
-- ============================================
-- Use this script to allow a user to change their username again
-- after they've already used their one-time change.

-- METHOD 1: Reset by User Email
-- Replace 'user@example.com' with the actual user's email
UPDATE profiles 
SET username_changed_at = NULL 
WHERE user_id = (
  SELECT id FROM auth.users WHERE email = 'user@example.com'
);

-- METHOD 2: Reset by User ID
-- Replace 'user-uuid-here' with the actual user's ID
-- UPDATE profiles 
-- SET username_changed_at = NULL 
-- WHERE user_id = 'user-uuid-here';

-- METHOD 3: Reset by Username
-- Replace 'John Doe' with the user's current name
-- UPDATE profiles 
-- SET username_changed_at = NULL 
-- WHERE full_name = 'John Doe';

-- ============================================
-- View All Users Who Have Changed Their Username
-- ============================================
SELECT 
  p.full_name,
  u.email,
  p.username_changed_at,
  p.created_at
FROM profiles p
JOIN auth.users u ON p.user_id = u.id
WHERE p.username_changed_at IS NOT NULL
ORDER BY p.username_changed_at DESC;

-- ============================================
-- View Users Who Can Still Change Username
-- ============================================
SELECT 
  p.full_name,
  u.email,
  p.created_at
FROM profiles p
JOIN auth.users u ON p.user_id = u.id
WHERE p.username_changed_at IS NULL
ORDER BY p.created_at DESC;
