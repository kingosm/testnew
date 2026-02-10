-- Add visibility control to restaurants
ALTER TABLE public.restaurants 
ADD COLUMN IF NOT EXISTS is_visible BOOLEAN DEFAULT true;

-- Update RLS policy to allow everyone to view only visible restaurants
-- Note: Super admins will still be able to manage all restaurants due to existing policies
DROP POLICY IF EXISTS "Restaurants are viewable by everyone" ON public.restaurants;
CREATE POLICY "Restaurants are viewable by everyone" 
ON public.restaurants FOR SELECT USING (is_visible = true OR has_role(auth.uid(), 'super_admin'));
