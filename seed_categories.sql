-- Seed Initial Categories (Provinces)
-- This script populates the database with the main Kurdistan provinces if they don't exist.

INSERT INTO categories (name, slug, description, image_url, category_type)
VALUES 
  ('Erbil', 'erbil', 'The ancient capital and heart of Kurdistan.', 'https://images.unsplash.com/photo-1623864190822-487053e1673b?w=800', 'province'),
  ('Sulaymaniyah', 'sulaymaniyah', 'The cultural capital dealing in art and literature.', 'https://images.unsplash.com/photo-1580835392095-24357731737e?w=800', 'province'),
  ('Duhok', 'duhok', 'Nature''s gateway with stunning mountains and valleys.', 'https://images.unsplash.com/photo-1599827667954-474be6f30279?w=800', 'province'),
  ('Halabja', 'halabja', 'A city of resilience and beautiful pomegranate orchards.', 'https://images.unsplash.com/photo-1594142724268-b3d953934f86?w=800', 'province')
ON CONFLICT (slug) DO NOTHING;

-- Also verify restaurants table exists (schema check)
-- This ensures the foreign key relation in CategoriesPage works.
