-- FULL DATABASE RESET
-- WARNING: This will delete ALL data in the database.

-- 1. Drop existing tables (cleaning up)
DROP TABLE IF EXISTS public.favorites CASCADE;
DROP TABLE IF EXISTS public.reviews CASCADE;
DROP TABLE IF EXISTS public.menu_items CASCADE;
DROP TABLE IF EXISTS public.restaurants CASCADE;
DROP TABLE IF EXISTS public.categories CASCADE;
DROP TABLE IF EXISTS public.user_roles CASCADE; -- Added
DROP TABLE IF EXISTS public.content_translations CASCADE; -- Added

-- 2. Re-create Categories (WITH category_type)
CREATE TABLE public.categories (
  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  name TEXT NOT NULL,
  description TEXT,
  image_url TEXT,
  slug TEXT NOT NULL UNIQUE,
  category_type TEXT DEFAULT 'general',
  parent_id UUID REFERENCES public.categories(id) ON DELETE SET NULL, -- Added parent_id for provinces
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
  updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

-- 3. Re-create Restaurants
CREATE TABLE public.restaurants (
  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  category_id UUID REFERENCES public.categories(id) ON DELETE SET NULL,
  name TEXT NOT NULL,
  description TEXT,
  image_url TEXT,
  address TEXT,
  phone TEXT,
  latitude DECIMAL(10, 8),
  longitude DECIMAL(11, 8),
  slug TEXT NOT NULL UNIQUE,
  is_visible BOOLEAN DEFAULT true,
  opening_hours TEXT, -- Added
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
  updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

-- 4. Re-create Menu Items
CREATE TABLE public.menu_items (
  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  restaurant_id UUID REFERENCES public.restaurants(id) ON DELETE CASCADE NOT NULL,
  name TEXT NOT NULL,
  description TEXT,
  price DECIMAL(10, 2),
  image_url TEXT,
  category TEXT,
  is_visible BOOLEAN DEFAULT true, -- Added
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

-- 5. Re-create Reviews
CREATE TABLE public.reviews (
  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  restaurant_id UUID REFERENCES public.restaurants(id) ON DELETE CASCADE NOT NULL,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  rating INTEGER NOT NULL CHECK (rating >= 1 AND rating <= 5),
  comment TEXT,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

-- 6. Re-create Favorites
CREATE TABLE public.favorites (
  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  restaurant_id UUID REFERENCES public.restaurants(id) ON DELETE CASCADE NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
  UNIQUE (user_id, restaurant_id)
);

-- 7. Re-create User Roles (Admin System)
CREATE TABLE public.user_roles (
  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  role TEXT NOT NULL DEFAULT 'super_admin' CHECK (role = 'super_admin'),
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
  UNIQUE(user_id, role)
);

-- 8. Re-create Content Translations (CMS)
CREATE TABLE public.content_translations (
    key text NOT NULL,
    language text NOT NULL,
    value text NOT NULL,
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_by uuid REFERENCES auth.users(id),
    PRIMARY KEY (key, language)
);

-- 9. Enable RLS
ALTER TABLE public.categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.restaurants ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.menu_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.reviews ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.favorites ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_roles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.content_translations ENABLE ROW LEVEL SECURITY;

-- 10. Helper Function
CREATE OR REPLACE FUNCTION public.has_role(user_id UUID, required_role TEXT)
RETURNS BOOLEAN AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM public.user_roles
    WHERE user_id = user_id AND role = required_role
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 11. Create Policies

-- Categories
CREATE POLICY "Public read categories" ON public.categories FOR SELECT USING (true);
CREATE POLICY "Admin all categories" ON public.categories FOR ALL USING (public.has_role(auth.uid(), 'super_admin'));

-- Restaurants
CREATE POLICY "Public read restaurants" ON public.restaurants FOR SELECT USING (true);
CREATE POLICY "Admin all restaurants" ON public.restaurants FOR ALL USING (public.has_role(auth.uid(), 'super_admin'));

-- Menu Items
CREATE POLICY "Public read menu_items" ON public.menu_items FOR SELECT USING (true);
CREATE POLICY "Admin all menu_items" ON public.menu_items FOR ALL USING (public.has_role(auth.uid(), 'super_admin'));

-- Reviews
CREATE POLICY "Public read reviews" ON public.reviews FOR SELECT USING (true);
CREATE POLICY "Auth create reviews" ON public.reviews FOR INSERT WITH CHECK (auth.uid() = user_id);
DROP POLICY IF EXISTS "Users can delete own reviews" ON public.reviews;
CREATE POLICY "Users can delete own reviews" ON public.reviews FOR DELETE USING (auth.uid() = user_id);

-- Favorites
CREATE POLICY "User manage favorites" ON public.favorites FOR ALL USING (auth.uid() = user_id);

-- User Roles
CREATE POLICY "Users can read own role" ON public.user_roles FOR SELECT USING (auth.uid() = user_id);

-- Content Translations
CREATE POLICY "Allow public read access" ON public.content_translations FOR SELECT USING (true);
CREATE POLICY "Allow admin write access" ON public.content_translations FOR ALL USING (public.has_role(auth.uid(), 'super_admin'));


-- 12. SEED DATA

-- Insert Provinces
INSERT INTO categories (name, slug, description, image_url, category_type)
VALUES 
  ('Erbil', 'erbil', 'The ancient capital and heart of Kurdistan.', 'https://images.unsplash.com/photo-1623864190822-487053e1673b?w=800', 'province'),
  ('Sulaymaniyah', 'sulaymaniyah', 'The cultural capital dealing in art and literature.', 'https://images.unsplash.com/photo-1580835392095-24357731737e?w=800', 'province'),
  ('Duhok', 'duhok', 'Nature''s gateway with stunning mountains and valleys.', 'https://images.unsplash.com/photo-1599827667954-474be6f30279?w=800', 'province'),
  ('Halabja', 'halabja', 'A city of resilience and beautiful pomegranate orchards.', 'https://images.unsplash.com/photo-1594142724268-b3d953934f86?w=800', 'province');

-- Sample Restaurant in Erbil
INSERT INTO restaurants (category_id, name, description, address, phone, latitude, longitude, slug, is_visible, image_url)
SELECT 
    id, 
    'Erbil Citadel Cafe', 
    'A historic cafe with a view.', 
    'Citadel, Erbil', 
    '07501234567', 
    36.1911, 
    44.0091, 
    'erbil-citadel-cafe', 
    true,
    'https://images.unsplash.com/photo-1559339352-11d035aa65de?w=800'
FROM categories WHERE slug = 'erbil';

-- Sample Restaurant in Suli
INSERT INTO restaurants (category_id, name, description, address, phone, latitude, longitude, slug, is_visible, image_url)
SELECT 
    id, 
    'Chavy Land Resto', 
    'Family dining in the park.', 
    'Chavy Land, Sulaymaniyah', 
    '07701234567', 
    35.5575, 
    45.4262, 
    'chavy-land-resto', 
    true,
    'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=800'
FROM categories WHERE slug = 'sulaymaniyah';
