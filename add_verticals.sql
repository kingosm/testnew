-- Comprehensive Hierarchy Script
-- Creates: Province -> District (City Center/Khabat) -> 5 Verticals -> Sample Places
-- for Erbil, Duhok, Silemani, Halabja, Kirkuk, Zakho, Soran, Ranya

DO $$
DECLARE
    -- Province IDs
    p_id UUID;
    dist_id UUID;
    
    -- Vertical IDs
    v_rest_id UUID;
    v_market_id UUID;
    v_mech_id UUID;
    v_mobile_id UUID;
    v_candy_id UUID;
    
    -- Loop variables
    prov record;
BEGIN
    ---------------------------------------------------------------------------
    -- 1. DEFINE PROVINCES
    ---------------------------------------------------------------------------
    -- We iteratively process each province to create 'City Center' + 5 Verticals
    FOR prov IN 
        SELECT * FROM (VALUES 
            ('Erbil', 'erbil', 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=800'),
            ('Duhok', 'duhok', 'https://images.unsplash.com/photo-1555939594-58d7cb561ad1?w=800'),
            ('Silemani', 'silemani', 'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=800'),
            ('Halabja', 'halabja', 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=800'),
            ('Kirkuk', 'kirkuk', 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=800'),
            ('Zakho', 'zakho', 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=800'),
            ('Soran', 'soran', 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=800'),
            ('Ranya', 'ranya', 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=800')
        ) AS t(name, slug, image)
    LOOP
        -- A. Create/Get Province
        INSERT INTO categories (name, slug, category_type, image_url) 
        VALUES (prov.name, prov.slug, 'province', prov.image)
        ON CONFLICT (slug) DO UPDATE SET category_type = 'province'
        RETURNING id INTO p_id;

        -- B. Create 'City Center' District
        INSERT INTO categories (name, slug, category_type, parent_id, image_url)
        VALUES ('City Center', prov.slug || '-city-center', 'district', p_id, prov.image)
        ON CONFLICT (slug) DO UPDATE SET parent_id = p_id, category_type = 'district'
        RETURNING id INTO dist_id;

        -- C. Create 5 Verticals for City Center
        
        -- 1. Restaurants
        INSERT INTO categories (name, slug, category_type, parent_id, image_url)
        VALUES ('Restaurants', prov.slug || '-cc-restaurants', 'vertical', dist_id, 'https://images.unsplash.com/photo-1555939594-58d7cb561ad1?w=800')
        ON CONFLICT (slug) DO UPDATE SET parent_id = dist_id, category_type = 'vertical'
        RETURNING id INTO v_rest_id;

        -- 2. Markets
        INSERT INTO categories (name, slug, category_type, parent_id, image_url)
        VALUES ('Markets', prov.slug || '-cc-markets', 'vertical', dist_id, 'https://images.unsplash.com/photo-1578916171728-46686eac8d58?w=800')
        ON CONFLICT (slug) DO UPDATE SET parent_id = dist_id, category_type = 'vertical'
        RETURNING id INTO v_market_id;

        -- 3. Mechanics
        INSERT INTO categories (name, slug, category_type, parent_id, image_url)
        VALUES ('Mechanics', prov.slug || '-cc-mechanics', 'vertical', dist_id, 'https://images.unsplash.com/photo-1619642751034-765dfdf7c58e?w=800')
        ON CONFLICT (slug) DO UPDATE SET parent_id = dist_id, category_type = 'vertical'
        RETURNING id INTO v_mech_id;

        -- 4. Mobile Shops
        INSERT INTO categories (name, slug, category_type, parent_id, image_url)
        VALUES ('Mobile Shops', prov.slug || '-cc-mobile-shops', 'vertical', dist_id, 'https://images.unsplash.com/photo-1596742578505-1c3906352936?w=800')
        ON CONFLICT (slug) DO UPDATE SET parent_id = dist_id, category_type = 'vertical'
        RETURNING id INTO v_mobile_id;

        -- 5. Candy Shop
        INSERT INTO categories (name, slug, category_type, parent_id, image_url)
        VALUES ('Candy Shop', prov.slug || '-cc-candy-shop', 'vertical', dist_id, 'https://images.unsplash.com/photo-1582058091505-f87a2e55a40f?w=800')
        ON CONFLICT (slug) DO UPDATE SET parent_id = dist_id, category_type = 'vertical'
        RETURNING id INTO v_candy_id;

        -- D. Create Sample Places (One for each)
        
        -- Restaurant
        INSERT INTO restaurants (category_id, name, description, address, phone, latitude, longitude, slug, image_url)
        VALUES (v_rest_id, prov.name || ' Royal Restaurant', 'Best food in city center', 'Main Square', '07500001001', 36.0, 44.0, prov.slug || '-royal-rest', 'https://images.unsplash.com/photo-1555939594-58d7cb561ad1?w=800')
        ON CONFLICT (slug) DO UPDATE SET category_id = v_rest_id;

        -- Market
        INSERT INTO restaurants (category_id, name, description, address, phone, latitude, longitude, slug, image_url)
        VALUES (v_market_id, prov.name || ' Central Market', 'Groceries and more', 'Market St', '07500001002', 36.0, 44.0, prov.slug || '-central-market', 'https://images.unsplash.com/photo-1488459716781-31db52582fe9?w=800')
        ON CONFLICT (slug) DO UPDATE SET category_id = v_market_id;

        -- Mechanic
        INSERT INTO restaurants (category_id, name, description, address, phone, latitude, longitude, slug, image_url)
        VALUES (v_mech_id, prov.name || ' Auto Care', 'Expert repairs', 'Industrial Zone', '07500001003', 36.0, 44.0, prov.slug || '-auto-care', 'https://images.unsplash.com/photo-1487754180451-c456f719a1fc?w=800')
        ON CONFLICT (slug) DO UPDATE SET category_id = v_mech_id;

         -- Mobile
        INSERT INTO restaurants (category_id, name, description, address, phone, latitude, longitude, slug, image_url)
        VALUES (v_mobile_id, prov.name || ' Mobile Zone', 'Latest smartphones', 'Tech Street', '07500001004', 36.0, 44.0, prov.slug || '-mobile-zone', 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=800')
        ON CONFLICT (slug) DO UPDATE SET category_id = v_mobile_id;

         -- Candy
        INSERT INTO restaurants (category_id, name, description, address, phone, latitude, longitude, slug, image_url)
        VALUES (v_candy_id, prov.name || ' Sweet House', 'Delicious treats', 'Dessert Ave', '07500001005', 36.0, 44.0, prov.slug || '-sweet-house', 'https://images.unsplash.com/photo-1582058091505-f87a2e55a40f?w=800')
        ON CONFLICT (slug) DO UPDATE SET category_id = v_candy_id;

    END LOOP;

    ---------------------------------------------------------------------------
    -- 2. ENSURE KHABAT (Specific Request) is maintained/updated
    ---------------------------------------------------------------------------
    
    SELECT id INTO p_id FROM categories WHERE slug = 'erbil';

    -- Create/Update Khabat
    INSERT INTO categories (name, slug, category_type, parent_id, image_url) VALUES
    ('Khabat', 'khabat', 'district', p_id, 'https://images.unsplash.com/photo-1518635017498-87f514b7516c?w=800')
    ON CONFLICT (slug) DO UPDATE SET parent_id = p_id, category_type = 'district'
    RETURNING id INTO dist_id;

    -- Create Verticals for Khabat
    INSERT INTO categories (name, slug, category_type, parent_id, image_url) VALUES
    ('Restaurants', 'khabat-restaurants', 'vertical', dist_id, 'https://images.unsplash.com/photo-1555939594-58d7cb561ad1?w=800') ON CONFLICT (slug) DO UPDATE SET parent_id = dist_id, category_type = 'vertical' RETURNING id INTO v_rest_id;
    INSERT INTO categories (name, slug, category_type, parent_id, image_url) VALUES
    ('Markets', 'khabat-markets', 'vertical', dist_id, 'https://images.unsplash.com/photo-1578916171728-46686eac8d58?w=800') ON CONFLICT (slug) DO UPDATE SET parent_id = dist_id, category_type = 'vertical' RETURNING id INTO v_market_id;
    INSERT INTO categories (name, slug, category_type, parent_id, image_url) VALUES
    ('Mechanics', 'khabat-mechanics', 'vertical', dist_id, 'https://images.unsplash.com/photo-1619642751034-765dfdf7c58e?w=800') ON CONFLICT (slug) DO UPDATE SET parent_id = dist_id, category_type = 'vertical' RETURNING id INTO v_mech_id;
    INSERT INTO categories (name, slug, category_type, parent_id, image_url) VALUES
    ('Mobile Shops', 'khabat-mobile-shops', 'vertical', dist_id, 'https://images.unsplash.com/photo-1596742578505-1c3906352936?w=800') ON CONFLICT (slug) DO UPDATE SET parent_id = dist_id, category_type = 'vertical' RETURNING id INTO v_mobile_id;
    INSERT INTO categories (name, slug, category_type, parent_id, image_url) VALUES
    ('Candy Shop', 'khabat-candy-shop', 'vertical', dist_id, 'https://images.unsplash.com/photo-1582058091505-f87a2e55a40f?w=800') ON CONFLICT (slug) DO UPDATE SET parent_id = dist_id, category_type = 'vertical' RETURNING id INTO v_candy_id;

    -- Add items for Khabat (Ensuring they exist)
    INSERT INTO restaurants (category_id, name, slug) VALUES (v_candy_id, 'Sweets of Khabat', 'sweets-of-khabat') ON CONFLICT (slug) DO UPDATE SET category_id = v_candy_id;
    INSERT INTO restaurants (category_id, name, slug) VALUES (v_market_id, 'Khabat Grand Bazaar', 'khabat-grand-bazaar') ON CONFLICT (slug) DO UPDATE SET category_id = v_market_id;

END $$;
