-- Add sample reviews for restaurants
-- Note: This requires active users in auth.users. 
-- Since we can't easily insert into auth.users, these samples will need to be linked to the first available profile if any exist, 
-- or we can provide the SQL for the user to run after they create an account.

-- Here is a script that adds sample reviews for the existing restaurants
-- It uses a cross join with the first profile found to simulate a user review.

DO $$ 
DECLARE 
    v_user_id UUID;
    v_zagros_id UUID;
    v_mountain_id UUID;
    v_khabat_id UUID;
BEGIN
    -- Get the first user profile (if any)
    SELECT user_id INTO v_user_id FROM public.profiles LIMIT 1;
    
    -- Get restaurant IDs by slug
    SELECT id INTO v_zagros_id FROM public.restaurants WHERE slug = 'zagros-kitchen';
    SELECT id INTO v_mountain_id FROM public.restaurants WHERE slug = 'mountain-view-restaurant';
    SELECT id INTO v_khabat_id FROM public.restaurants WHERE slug = 'khabat-grill-house';

    -- Fallback: if those specific ones aren't found, just grab any restaurants
    IF v_zagros_id IS NULL THEN
        SELECT id INTO v_zagros_id FROM public.restaurants LIMIT 1 OFFSET 0;
    END IF;
    IF v_mountain_id IS NULL THEN
        SELECT id INTO v_mountain_id FROM public.restaurants LIMIT 1 OFFSET 1;
    END IF;
    IF v_khabat_id IS NULL THEN
        SELECT id INTO v_khabat_id FROM public.restaurants LIMIT 1 OFFSET 2;
    END IF;

    IF v_user_id IS NOT NULL THEN
        -- Zagros Kitchen Reviews (or first restaurant)
        IF v_zagros_id IS NOT NULL THEN
            INSERT INTO public.reviews (restaurant_id, user_id, rating, comment) VALUES
            (v_zagros_id, v_user_id, 5, 'Best kebab in town! The flavor is authentic and the service is great.'),
            (v_zagros_id, v_user_id, 4, 'Very good food, but a bit loud during peak hours.');
        END IF;

        -- Mountain View Reviews (or second restaurant)
        IF v_mountain_id IS NOT NULL THEN
            INSERT INTO public.reviews (restaurant_id, user_id, rating, comment) VALUES
            (v_mountain_id, v_user_id, 5, 'The view is unbeatable. Perfect for a sunset dinner.'),
            (v_mountain_id, v_user_id, 5, 'Five stars just for the atmosphere!');
        END IF;

        -- Khabat Grill Reviews (or third restaurant)
        IF v_khabat_id IS NOT NULL THEN
            INSERT INTO public.reviews (restaurant_id, user_id, rating, comment) VALUES
            (v_khabat_id, v_user_id, 4, 'Solid grill house. Portions are huge!');
        END IF;
    END IF;
END $$;
