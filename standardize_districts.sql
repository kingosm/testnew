-- Standardize District Categories
-- Ensures every category of type 'district' has the standard 5 verticals:
-- Restaurants, Markets, Mechanics, Mobile Shops, Candy Shop

DO $$
DECLARE
    r_district RECORD;
    v_verticals TEXT[] := ARRAY['Restaurants', 'Markets', 'Mechanics', 'Mobile Shops', 'Candy Shop'];
    v_images TEXT[] := ARRAY[
        'https://images.unsplash.com/photo-1555939594-58d7cb561ad1?w=800', -- Restaurants
        'https://images.unsplash.com/photo-1578916171728-46686eac8d58?w=800', -- Markets
        'https://images.unsplash.com/photo-1619642751034-765dfdf7c58e?w=800', -- Mechanics
        'https://images.unsplash.com/photo-1596742578505-1c3906352936?w=800',  -- Mobile Shops
        'https://images.unsplash.com/photo-1582058091505-f87a2e55a40f?w=800'   -- Candy Shop
    ];
    v_name TEXT;
    v_slug TEXT;
    v_img TEXT;
    i INT;
    v_exists BOOLEAN;
BEGIN
    -- Loop through all districts
    FOR r_district IN SELECT * FROM categories WHERE category_type = 'district'
    LOOP
        RAISE NOTICE 'Processing District: % (%)', r_district.name, r_district.slug;
        
        FOR i IN 1..array_length(v_verticals, 1)
        LOOP
            v_name := v_verticals[i];
            v_img := v_images[i];
            
            -- Check if this vertical already exists for this district (by name)
            SELECT EXISTS (
                SELECT 1 FROM categories 
                WHERE parent_id = r_district.id 
                AND category_type = 'vertical' 
                AND name = v_name
            ) INTO v_exists;
            
            IF NOT v_exists THEN
                -- Create slug: district-slug-vertical-slug (e.g., khabat-restaurants)
                -- Handle slug uniqueness just in case
                v_slug := r_district.slug || '-' || lower(replace(v_name, ' ', '-'));
                
                RAISE NOTICE '  Creating Vertical: % (Slug: %)', v_name, v_slug;
                
                INSERT INTO categories (name, slug, category_type, parent_id, image_url)
                VALUES (v_name, v_slug, 'vertical', r_district.id, v_img)
                ON CONFLICT (slug) DO NOTHING; -- Skip if slug collides (unlikely but safe)
            ELSE
                RAISE NOTICE '  Vertical % already exists.', v_name;
            END IF;
            
        END LOOP;
    END LOOP;
END $$;
