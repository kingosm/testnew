-- Fix RLS on Categories
-- Ensure Row Level Security is enabled
ALTER TABLE categories ENABLE ROW LEVEL SECURITY;

-- Drop existing policy if it exists to avoid conflicts (or just create if not exists)
DROP POLICY IF EXISTS "Allow public read access on categories" ON categories;

-- Create policy to allow everyone to read categories
CREATE POLICY "Allow public read access on categories"
ON categories FOR SELECT
USING (true);

-- Grant select permission to anon and authenticated roles
GRANT SELECT ON categories TO anon, authenticated;
