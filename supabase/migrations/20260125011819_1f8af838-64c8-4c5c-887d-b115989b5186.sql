-- Create app_role enum for user roles
CREATE TYPE public.app_role AS ENUM ('super_admin', 'user');

-- Create profiles table
CREATE TABLE public.profiles (
  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL UNIQUE,
  full_name TEXT,
  avatar_url TEXT,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
  updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

-- Create user_roles table
CREATE TABLE public.user_roles (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  role app_role NOT NULL,
  UNIQUE (user_id, role)
);

-- Create categories table
CREATE TABLE public.categories (
  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  name TEXT NOT NULL,
  description TEXT,
  image_url TEXT,
  slug TEXT NOT NULL UNIQUE,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
  updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

-- Create restaurants table
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
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
  updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

-- Create menu_items table
CREATE TABLE public.menu_items (
  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  restaurant_id UUID REFERENCES public.restaurants(id) ON DELETE CASCADE NOT NULL,
  name TEXT NOT NULL,
  description TEXT,
  price DECIMAL(10, 2),
  image_url TEXT,
  category TEXT,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

-- Create reviews table
CREATE TABLE public.reviews (
  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  restaurant_id UUID REFERENCES public.restaurants(id) ON DELETE CASCADE NOT NULL,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  rating INTEGER NOT NULL CHECK (rating >= 1 AND rating <= 5),
  comment TEXT,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

-- Create favorites table
CREATE TABLE public.favorites (
  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  restaurant_id UUID REFERENCES public.restaurants(id) ON DELETE CASCADE NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
  UNIQUE (user_id, restaurant_id)
);

-- Enable RLS on all tables
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_roles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.restaurants ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.menu_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.reviews ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.favorites ENABLE ROW LEVEL SECURITY;

-- Create security definer function to check roles
CREATE OR REPLACE FUNCTION public.has_role(_user_id UUID, _role app_role)
RETURNS BOOLEAN
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT EXISTS (
    SELECT 1
    FROM public.user_roles
    WHERE user_id = _user_id
      AND role = _role
  )
$$;

-- Profiles policies
CREATE POLICY "Public profiles are viewable by everyone" 
ON public.profiles FOR SELECT USING (true);

CREATE POLICY "Users can update their own profile" 
ON public.profiles FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own profile" 
ON public.profiles FOR INSERT WITH CHECK (auth.uid() = user_id);

-- User roles policies
CREATE POLICY "Users can view their own roles" 
ON public.user_roles FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Super admins can manage roles"
ON public.user_roles FOR ALL 
USING (public.has_role(auth.uid(), 'super_admin'));

-- Categories policies (public read, admin write)
CREATE POLICY "Categories are viewable by everyone" 
ON public.categories FOR SELECT USING (true);

CREATE POLICY "Super admins can manage categories"
ON public.categories FOR ALL 
USING (public.has_role(auth.uid(), 'super_admin'));

-- Restaurants policies (public read, admin write)
CREATE POLICY "Restaurants are viewable by everyone" 
ON public.restaurants FOR SELECT USING (true);

CREATE POLICY "Super admins can manage restaurants"
ON public.restaurants FOR ALL 
USING (public.has_role(auth.uid(), 'super_admin'));

-- Menu items policies (public read, admin write)
CREATE POLICY "Menu items are viewable by everyone" 
ON public.menu_items FOR SELECT USING (true);

CREATE POLICY "Super admins can manage menu items"
ON public.menu_items FOR ALL 
USING (public.has_role(auth.uid(), 'super_admin'));

-- Reviews policies
CREATE POLICY "Reviews are viewable by everyone" 
ON public.reviews FOR SELECT USING (true);

CREATE POLICY "Authenticated users can create reviews" 
ON public.reviews FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own reviews" 
ON public.reviews FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own reviews" 
ON public.reviews FOR DELETE USING (auth.uid() = user_id);

-- Favorites policies
CREATE POLICY "Users can view their own favorites" 
ON public.favorites FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can create their own favorites" 
ON public.favorites FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete their own favorites" 
ON public.favorites FOR DELETE USING (auth.uid() = user_id);

-- Create function to update timestamps
CREATE OR REPLACE FUNCTION public.update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SET search_path = public;

-- Create triggers for timestamp updates
CREATE TRIGGER update_profiles_updated_at
BEFORE UPDATE ON public.profiles
FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER update_categories_updated_at
BEFORE UPDATE ON public.categories
FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER update_restaurants_updated_at
BEFORE UPDATE ON public.restaurants
FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

-- Create function to handle new user signup
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.profiles (user_id, full_name, avatar_url)
  VALUES (
    NEW.id,
    COALESCE(NEW.raw_user_meta_data ->> 'full_name', NEW.raw_user_meta_data ->> 'name'),
    NEW.raw_user_meta_data ->> 'avatar_url'
  );
  
  INSERT INTO public.user_roles (user_id, role)
  VALUES (NEW.id, 'user');
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;

-- Create trigger for new user signup
CREATE TRIGGER on_auth_user_created
AFTER INSERT ON auth.users
FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- Insert default categories
INSERT INTO public.categories (name, description, slug, image_url) VALUES
('Kalak', 'Discover amazing restaurants in Kalak region', 'kalak', 'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=800'),
('Khabat', 'Explore the best dining spots in Khabat', 'khabat', 'https://images.unsplash.com/photo-1552566626-52f8b828add9?w=800');

-- Insert sample restaurants
INSERT INTO public.restaurants (category_id, name, description, address, phone, latitude, longitude, slug, image_url) 
SELECT 
  c.id,
  'Zagros Kitchen',
  'Traditional Kurdish cuisine with a modern twist. Experience the authentic flavors of Kurdistan.',
  '123 Main Street, Kalak',
  '+964 750 123 4567',
  36.1901,
  44.0092,
  'zagros-kitchen',
  'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?w=800'
FROM public.categories c WHERE c.slug = 'kalak';

INSERT INTO public.restaurants (category_id, name, description, address, phone, latitude, longitude, slug, image_url) 
SELECT 
  c.id,
  'Mountain View Restaurant',
  'Scenic dining with breathtaking mountain views. Fresh ingredients and warm hospitality.',
  '456 Hill Road, Kalak',
  '+964 750 234 5678',
  36.1850,
  44.0150,
  'mountain-view-restaurant',
  'https://images.unsplash.com/photo-1559339352-11d035aa65de?w=800'
FROM public.categories c WHERE c.slug = 'kalak';

INSERT INTO public.restaurants (category_id, name, description, address, phone, latitude, longitude, slug, image_url) 
SELECT 
  c.id,
  'Khabat Grill House',
  'Premium grilled meats and kebabs. A local favorite for over 20 years.',
  '789 Center Street, Khabat',
  '+964 750 345 6789',
  36.2651,
  43.6678,
  'khabat-grill-house',
  'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=800'
FROM public.categories c WHERE c.slug = 'khabat';

-- Insert sample menu items
INSERT INTO public.menu_items (restaurant_id, name, description, price, category)
SELECT r.id, 'Kurdish Kebab', 'Tender lamb kebab with traditional spices', 15.00, 'Main Course'
FROM public.restaurants r WHERE r.slug = 'zagros-kitchen';

INSERT INTO public.menu_items (restaurant_id, name, description, price, category)
SELECT r.id, 'Dolma', 'Grape leaves stuffed with rice and herbs', 12.00, 'Appetizer'
FROM public.restaurants r WHERE r.slug = 'zagros-kitchen';

INSERT INTO public.menu_items (restaurant_id, name, description, price, category)
SELECT r.id, 'Biryani', 'Fragrant rice with saffron and tender chicken', 18.00, 'Main Course'
FROM public.restaurants r WHERE r.slug = 'zagros-kitchen';