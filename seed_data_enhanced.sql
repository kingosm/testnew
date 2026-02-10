-- Enhanced Seed Data Script
-- Adds categories, restaurants, menu items, and reviews
-- Run this in the Supabase SQL Editor

-- 1. Ensure Categories Exist
INSERT INTO public.categories (name, description, slug, image_url) VALUES
('Erbil', 'Experience the rich culinary heritage of Erbil', 'erbil', 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=800'),
('Duhok', 'Taste the unique flavors of Duhok region', 'duhok', 'https://images.unsplash.com/photo-1555939594-58d7cb561ad1?w=800'),
('Silemani', 'Discover the cultural capital of food in Silemani', 'silemani', 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=800')
ON CONFLICT (slug) DO NOTHING;

-- 2. Ensure Restaurants Exist (Upsert)
INSERT INTO public.restaurants (category_id, name, description, address, phone, latitude, longitude, slug, image_url) 
VALUES 
-- Kalak Restaurants
((SELECT id FROM public.categories WHERE slug = 'kalak'), 'Zagros Kitchen', 'Traditional Kurdish cuisine with a modern twist.', '123 Main St, Kalak', '+964 750 111 2222', 36.1901, 44.0092, 'zagros-kitchen', 'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?w=800'),
((SELECT id FROM public.categories WHERE slug = 'kalak'), 'Mountain View Restaurant', 'Dining with a breathtaking view of the mountains.', 'Mountain Rd, Kalak', '+964 750 333 4444', 36.1950, 44.0100, 'mountain-view-restaurant', 'https://images.unsplash.com/photo-1559339352-11d035aa65de?w=800'),
-- Khabat Restaurants
((SELECT id FROM public.categories WHERE slug = 'khabat'), 'Khabat Grill House', 'Famous for its grilled meats and kebabs.', 'Khabat Center', '+964 750 555 6666', 36.2500, 43.8000, 'khabat-grill-house', 'https://images.unsplash.com/photo-1555939594-58d7cb561ad1?w=800'),
-- Erbil Restaurants
((SELECT id FROM public.categories WHERE slug = 'erbil'), 'Erbil Castle Dining', 'Luxury dining near the historic citadel.', 'Citadel St, Erbil', '+964 750 777 8888', 36.1911, 44.0091, 'erbil-castle-dining', 'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=800'),
((SELECT id FROM public.categories WHERE slug = 'erbil'), 'Chaikhana Machko', 'Historic tea house with traditional snacks.', 'Qaysari Bazaar, Erbil', '+964 750 999 0000', 36.1890, 44.0110, 'chaikhana-machko', 'https://images.unsplash.com/photo-1511920170033-f8396924c348?w=800'),
-- Duhok Restaurants
((SELECT id FROM public.categories WHERE slug = 'duhok'), 'Duhok Kebab House', 'The best kebab in Duhok.', 'Azadi Park, Duhok', '+964 750 123 9876', 36.8679, 42.9486, 'duhok-kebab-house', 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=800'),
-- Silemani Restaurants
((SELECT id FROM public.categories WHERE slug = 'silemani'), 'Silemani Dolma', 'Specializing in homemade Dolma.', 'Salim St, Silemani', '+964 750 321 6549', 35.5500, 45.4333, 'silemani-dolma', 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=800')
ON CONFLICT (slug) DO UPDATE SET 
    description = EXCLUDED.description,
    image_url = EXCLUDED.image_url,
    address = EXCLUDED.address,
    category_id = EXCLUDED.category_id;


-- 3. Add Menu Items for ALL Restaurants
DO $$
DECLARE
    r_record RECORD;
    v_restaurant_id UUID;
    v_category TEXT;
BEGIN
    FOR r_record IN SELECT id, name, slug FROM public.restaurants LOOP
        
        -- Delete existing items to avoid duplicates if re-running
        DELETE FROM public.menu_items WHERE restaurant_id = r_record.id;

        -- Common items for all
        INSERT INTO public.menu_items (restaurant_id, name, description, price, category, image_url) VALUES
        (r_record.id, 'Lentil Soup', 'Warm and comforting traditional lentil soup', 3000, 'Salads', 'https://images.unsplash.com/photo-1547592166-23acbe346499?w=800'),
        (r_record.id, 'Mixed Kebab Platter', 'Assortment of grilled meats served with rice and salad', 15000, 'Foods', 'https://images.unsplash.com/photo-1555939594-58d7cb561ad1?w=800'),
        (r_record.id, 'Traditional Dolma', 'Grape leaves stuffed with rice and herbs', 8000, 'Foods', 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=800'),
        (r_record.id, 'Baklava', 'Rich, sweet dessert pastry made of layers of filo filled with chopped nuts', 4000, 'Sweets', 'https://images.unsplash.com/photo-1519676867240-f03562e64548?w=800'),
        (r_record.id, 'Kunafa', 'Traditional spun pastry soaked in sweet, sugar-based syrup', 5000, 'Sweets', 'https://images.unsplash.com/photo-1587314168485-3236d6710814?w=800'),
        (r_record.id, 'Kurdish Tea', 'Authentic black tea', 1000, 'Drinks', 'https://images.unsplash.com/photo-1511920170033-f8396924c348?w=800'),
        (r_record.id, 'Ayran (Doogh)', 'Refreshing yogurt drink', 1500, 'Drinks', 'https://images.unsplash.com/photo-1513558161293-cdaf765ed2fd?w=800');

        -- Specific items based on restaurant name (simple logic)
        IF r_record.slug = 'zagros-kitchen' THEN
             INSERT INTO public.menu_items (restaurant_id, name, description, price, category, image_url) VALUES
             (r_record.id, 'Zagros Special', 'Chef''s special lamb dish', 20000, 'Foods', 'https://images.unsplash.com/photo-1544025162-d76690b6d012?w=800');
        END IF;

         IF r_record.slug = 'chaikhana-machko' THEN
             INSERT INTO public.menu_items (restaurant_id, name, description, price, category, image_url) VALUES
             (r_record.id, 'Special Blend Tea', 'Machko''s famous tea blend', 2000, 'Drinks', 'https://images.unsplash.com/photo-1511920170033-f8396924c348?w=800'),
             (r_record.id, 'Baklava', 'Sweet pastry with nuts', 3000, 'Sweets', 'https://images.unsplash.com/photo-1519676867240-f03562e64548?w=800');
        END IF;

    END LOOP;
END $$;


-- 4. Add Reviews for ALL Restaurants
DO $$
DECLARE
    r_record RECORD;
    v_user_id UUID;
BEGIN
    -- Get a user ID to attribute reviews to (first available user)
    SELECT id INTO v_user_id FROM auth.users LIMIT 1;

    -- If no user exists, we can't add reviews with a valid user_id
    IF v_user_id IS NOT NULL THEN
        FOR r_record IN SELECT id FROM public.restaurants LOOP
            
            -- Clear existing reviews for this user to avoid unique constraint issues if re-running
            -- (reviews table likely doesn't have unique constraint on user+restaurant but just in case)
            DELETE FROM public.reviews WHERE restaurant_id = r_record.id AND user_id = v_user_id;

            INSERT INTO public.reviews (restaurant_id, user_id, rating, comment) VALUES
            (r_record.id, v_user_id, 5, 'Absolutely delicious! Highly recommended.'),
            (r_record.id, v_user_id, 4, 'Great atmosphere and friendly staff.'),
            (r_record.id, v_user_id, 5, 'The food was fresh and tasty. Will come back again!'),
            (r_record.id, v_user_id, 4, 'Really enjoyed the sweets here.'),
            (r_record.id, v_user_id, 5, 'Best dining experience in the city.'),
            (r_record.id, v_user_id, 3, 'Good food but service was a bit slow.');
            
        END LOOP;
    END IF;
END $$;
