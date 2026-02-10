-- Fix Database Schema and Seed Data

-- 1. Add the missing column 'category_type' if it doesn't exist
DO $$ 
BEGIN 
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'categories' AND column_name = 'category_type') THEN
        ALTER TABLE categories ADD COLUMN category_type TEXT DEFAULT 'general';
    END IF;
END $$;

-- 2. Insert the missing Provinces (Safe Insert)
INSERT INTO categories (name, slug, description, image_url, category_type)
VALUES 
  ('Erbil', 'erbil', 'The ancient capital and heart of Kurdistan.', 'https://images.unsplash.com/photo-1623864190822-487053e1673b?w=800', 'province'),
  ('Sulaymaniyah', 'sulaymaniyah', 'The cultural capital dealing in art and literature.', 'https://images.unsplash.com/photo-1580835392095-24357731737e?w=800', 'province'),
  ('Duhok', 'duhok', 'Nature''s gateway with stunning mountains and valleys.', 'https://images.unsplash.com/photo-1599827667954-474be6f30279?w=800', 'province'),
  ('Halabja', 'halabja', 'A city of resilience and beautiful pomegranate orchards.', 'https://images.unsplash.com/photo-1594142724268-b3d953934f86?w=800', 'province')
ON CONFLICT (slug) 
DO UPDATE SET category_type = 'province'; -- Ensure existing ones are updated to province if they exist

-- 3. Ensure RLS allows reading
ALTER TABLE categories ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Allow public read access on categories" ON categories;

CREATE POLICY "Allow public read access on categories"
ON categories FOR SELECT
USING (true);

GRANT SELECT ON categories TO anon, authenticated;
