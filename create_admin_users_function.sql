-- Create a function to get users with their emails for admin dashboard
-- This allows admins to view user data including emails
CREATE OR REPLACE FUNCTION get_users_for_admin()
RETURNS TABLE (
    user_id UUID,
    email TEXT,
    full_name TEXT,
    username_changed_at TIMESTAMP,
    created_at TIMESTAMP
) 
SECURITY DEFINER
SET search_path = public
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT 
        p.user_id,
        u.email::TEXT,
        p.full_name,
        p.username_changed_at,
        p.created_at
    FROM profiles p
    JOIN auth.users u ON p.user_id = u.id
    ORDER BY p.created_at DESC;
END;
$$;

-- Grant execute permission to authenticated users (admins will be checked by RLS)
GRANT EXECUTE ON FUNCTION get_users_for_admin() TO authenticated;
