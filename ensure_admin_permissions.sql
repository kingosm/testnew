-- Ensure Admin Permissions for Categories and Restaurants
-- This script ensures that users with 'admin' or 'super_admin' roles can fully manage data.

-- 1. Enable RLS on tables (if not already enabled)
ALTER TABLE categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE restaurants ENABLE ROW LEVEL SECURITY;

-- 2. Drop existing policies to avoid conflicts (optional, but cleaner)
DROP POLICY IF EXISTS "Enable read access for all users" ON categories;
DROP POLICY IF EXISTS "Enable insert for admins" ON categories;
DROP POLICY IF EXISTS "Enable update for admins" ON categories;
DROP POLICY IF EXISTS "Enable delete for admins" ON categories;

DROP POLICY IF EXISTS "Enable read access for all users" ON restaurants;
DROP POLICY IF EXISTS "Enable insert for admins" ON restaurants;
DROP POLICY IF EXISTS "Enable update for admins" ON restaurants;
DROP POLICY IF EXISTS "Enable delete for admins" ON restaurants;


-- 3. Create Policies for Categories

-- READ: Everyone can read
CREATE POLICY "Enable read access for all users" ON categories 
FOR SELECT USING (true);

-- INSERT: Only Admins can insert
CREATE POLICY "Enable insert for admins" ON categories 
FOR INSERT TO authenticated 
WITH CHECK (
  auth.uid() IN (
    SELECT user_id FROM user_roles WHERE role IN ('admin', 'super_admin')
  )
);

-- UPDATE: Only Admins can update
CREATE POLICY "Enable update for admins" ON categories 
FOR UPDATE TO authenticated 
USING (
  auth.uid() IN (
    SELECT user_id FROM user_roles WHERE role IN ('admin', 'super_admin')
  )
);

-- DELETE: Only Admins can delete
CREATE POLICY "Enable delete for admins" ON categories 
FOR DELETE TO authenticated 
USING (
  auth.uid() IN (
    SELECT user_id FROM user_roles WHERE role IN ('admin', 'super_admin')
  )
);


-- 4. Create Policies for Restaurants

-- READ: Everyone can read visible restaurants (or all if admin)
CREATE POLICY "Enable read access for all users" ON restaurants 
FOR SELECT USING (is_visible = true OR auth.uid() IN (SELECT user_id FROM user_roles WHERE role IN ('admin', 'super_admin')));

-- INSERT: Only Admins can insert
CREATE POLICY "Enable insert for admins" ON restaurants 
FOR INSERT TO authenticated 
WITH CHECK (
  auth.uid() IN (
    SELECT user_id FROM user_roles WHERE role IN ('admin', 'super_admin')
  )
);

-- UPDATE: Only Admins can update
CREATE POLICY "Enable update for admins" ON restaurants 
FOR UPDATE TO authenticated 
USING (
  auth.uid() IN (
    SELECT user_id FROM user_roles WHERE role IN ('admin', 'super_admin')
  )
);

-- DELETE: Only Admins can delete
CREATE POLICY "Enable delete for admins" ON restaurants 
FOR DELETE TO authenticated 
USING (
  auth.uid() IN (
    SELECT user_id FROM user_roles WHERE role IN ('admin', 'super_admin')
  )
);

-- 5. Helper Function for checking roles (if not exists)
CREATE OR REPLACE FUNCTION public.is_admin()
RETURNS BOOLEAN AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM user_roles 
    WHERE user_id = auth.uid() 
    AND role IN ('admin', 'super_admin')
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
