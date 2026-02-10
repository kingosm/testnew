-- Seed Global Verticals for Nearby Page Filtering
-- Run this in your Supabase SQL Editor

INSERT INTO categories (name, slug, category_type, parent_id, image_url)
VALUES
('Restaurants', 'restaurants', 'vertical', NULL, 'https://images.unsplash.com/photo-1555939594-58d7cb561ad1?w=800'),
('Cafes', 'cafes', 'vertical', NULL, 'https://images.unsplash.com/photo-1509042239860-f550ce710b93?w=800'),
('Gyms', 'gyms', 'vertical', NULL, 'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=800'),
('Markets', 'markets', 'vertical', NULL, 'https://images.unsplash.com/photo-1578916171728-46686eac8d58?w=800'),
('Bakeries', 'bakeries', 'vertical', NULL, 'https://images.unsplash.com/photo-1555507036-ab1f40388085?w=800')
ON CONFLICT (slug) DO NOTHING;
